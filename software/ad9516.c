#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/time.h>
#include <math.h>


#include "speclib.h"

#include "regs/dds_regs.h"

#include "filters.h"

void loader_low_level() {};

struct wr_rf_device {
    void *card;
    uint32_t base;
};


static inline void rf_writel(struct wr_rf_device *dev, uint32_t data, uint32_t addr)
{
    spec_writel(dev->card, data, addr + dev->base);
}

static inline uint32_t rf_readl(struct wr_rf_device *dev, uint32_t addr)
{
    return spec_readl (dev->card, addr + dev->base);
}

static void gpio_set(struct wr_rf_device *dev, uint32_t pin, int value)
{
    uint32_t g = rf_readl(dev, DDS_REG_GPIOR);
    if(value)
	rf_writel(dev, g | pin, DDS_REG_GPIOR);
    else
	rf_writel(dev, g & ~pin, DDS_REG_GPIOR);
}

static int gpio_get(struct wr_rf_device *dev, uint32_t pin)
{
    return rf_readl(dev, DDS_REG_GPIOR) & pin;
}


/* Returns the numer of microsecond timer ticks */
int64_t get_tics()
{
    struct timezone tz= {0,0};
    struct timeval tv;
    gettimeofday(&tv, &tz);
    return (int64_t)tv.tv_sec * 1000000LL + (int64_t) tv.tv_usec;
}

/* Microsecond-accurate delay */
void udelay(uint32_t usecs)
{
  int64_t ts = get_tics();

  while(get_tics() - ts < (int64_t)usecs);
}

static int extra_debug = 1;

void dbg(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
	if(extra_debug)
    vfprintf(stderr,fmt,ap);
    va_end(ap);
}


void spi_txrx(struct wr_rf_device *dev, uint32_t cs_pin, int n_bits, uint32_t value, uint32_t *rval)
{
    udelay(10);
    gpio_set(dev, DDS_GPIOR_PLL_SCLK, 0);
    udelay(10);
    gpio_set(dev, cs_pin, 0);
    udelay(10);
    int i;
    uint32_t rv = 0;


    for(i = 0; i<n_bits; i++)
    {
	value <<= 1;
	gpio_set(dev, DDS_GPIOR_PLL_SDIO, value & (1<<n_bits));
        udelay(10);
        gpio_set(dev, DDS_GPIOR_PLL_SCLK, 1);
        udelay(10);
	rv <<= 1;
	rv |= gpio_get(dev, DDS_GPIOR_PLL_SDIO) ? 1 : 0;
        udelay(10);
        gpio_set(dev, DDS_GPIOR_PLL_SCLK, 0);
        udelay(10);


    }

    gpio_set(dev, cs_pin, 1);

    if(rval)
	*rval = rv;
}

/* Reads a register from AD9516 */
static inline uint8_t ad951x_read_reg(struct wr_rf_device *dev, uint32_t cs_pin, uint16_t reg)
{
	uint32_t rval;
	spi_txrx(dev, cs_pin, 24, ((uint32_t)(reg & 0xfff) << 8) | (1<<23), &rval);
	return rval & 0xff;
}



/* Writes an AD9516 register */
static inline void ad951x_write_reg(struct wr_rf_device *dev, uint32_t cs_pin, uint16_t reg, uint8_t val)
{
	spi_txrx(dev, cs_pin, 24, ((uint32_t)(reg & 0xfff) << 8) | val, NULL);

//	dbg("write %x val %x readback %x\n", reg, val, ad951x_read_reg(dev, cs_pin, reg));
}


static int ad9516_init(struct wr_rf_device *dev)
{
    gpio_set(dev, DDS_GPIOR_PLL_SYS_RESET_N, 0);
    udelay(1000);
    gpio_set(dev, DDS_GPIOR_PLL_SYS_RESET_N, 1);
    udelay(1000);

    ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0, 0x99);
    ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0x232, 1);

    static struct {
	int reg;
	int val;
    } regs [] = {
	#include "regs/ad9516_init.h"
    };

      /* Check if the chip is present by reading its ID register */
    dbg("AD9516 PLL ID Register = %x\n", ad951x_read_reg(dev, DDS_GPIOR_PLL_SYS_CS_N,  0x3));

  /* Check if the chip is present by reading its ID register */
  if(ad951x_read_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0x3) != 0xc3)
    {
      dbg("%s: AD9516 PLL not responding.\n", __FUNCTION__);
      return -1;
    }

    int i;
  /* Load the regs */
    for(i=0;regs[i].reg >=0 ;i++)
	ad951x_write_reg (dev, DDS_GPIOR_PLL_SYS_CS_N, regs[i].reg, regs[i].val);

  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0x232, 0);
  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0x232, 1);

  /* Wait until the PLL has locked */
    uint64_t  start_tics = get_tics();
    uint64_t lock_timeout = 1000000ULL;
  for(;;)
    {
      if(ad951x_read_reg(dev,DDS_GPIOR_PLL_SYS_CS_N, 0x1f) & 1)
	break;

      if(get_tics() - start_tics > lock_timeout)
	{
	  dbg("%s: AD9516 PLL does not lock.\n", __FUNCTION__);
	  return -1;
	}
      udelay(100);
    }

  /* Synchronize the phase of all clock outputs (this is critical for the accuracy!) */
  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N,  0x230, 1);
  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N,  0x232, 1);
  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N,  0x230, 0);
  ad951x_write_reg(dev, DDS_GPIOR_PLL_SYS_CS_N, 0x232, 1);

  dbg("%s: AD9516 locked.\n", __FUNCTION__);


}

void reset_core(struct wr_rf_device *dev)
{
  rf_writel(dev, DDS_RSTR_PLL_RST, DDS_REG_RSTR);
  udelay(10);
  rf_writel(dev, 0, DDS_REG_RSTR);
  udelay(10);
  rf_writel(dev, DDS_RSTR_SW_RST, DDS_REG_RSTR);
  udelay(10);
  rf_writel(dev, 0, DDS_REG_RSTR);
  udelay(10000);
}

void set_center_freq(struct wr_rf_device *dev, double freq, double sample_rate)
{
    uint64_t tune =(uint64_t) ( (double)(1ULL<<42) * (freq / sample_rate) * 8.0 ); 
      
    dbg("Setting DDS center freq to: %.3f MHz (Fs = %.3f MHz), tune = 0x%llx\n", freq/1e6, sample_rate/1e6, tune);

    rf_writel(dev, (tune >> 32) & 0xffffffffULL, DDS_REG_FREQ_HI);
    rf_writel(dev, tune & 0xffffffffULL, DDS_REG_FREQ_LO);

//    dbg("Freq_Lo 0x%x\n", rf_readl(dev,  DDS_REG_FREQ_LO));
//    dbg("Freq_Hi 0x%x\n", rf_readl(dev,  DDS_REG_FREQ_HI));
}

void adf4002_write(struct wr_rf_device *dev, uint32_t value)
{
    gpio_set(dev, DDS_GPIOR_ADF_CLK, 0);
    udelay(10);
    gpio_set(dev, DDS_GPIOR_ADF_LE, 0);
    udelay(10);
    int i;
    for(i=0;i<24;i++)
    {
	value <<= 1;
	gpio_set(dev, DDS_GPIOR_ADF_DATA, value & (1<<24) ? 1 : 0);
        udelay(10);
        gpio_set(dev, DDS_GPIOR_ADF_CLK, 1);
        udelay(10);
        gpio_set(dev, DDS_GPIOR_ADF_CLK, 0);
        	
    }
    gpio_set(dev, DDS_GPIOR_ADF_LE, 1);
    udelay(10);

}

void adf4002_configure(struct wr_rf_device *dev, int r_div, int n_div, int mon_output)
{
    gpio_set(dev, DDS_GPIOR_ADF_CE, 1); /* enable the PD */
    udelay(10);

    adf4002_write(dev, 0 | (r_div << 2));
    adf4002_write(dev, 1 | (n_div << 8));
    adf4002_write(dev, 2 | (0<<7) | ( mon_output << 4)); /* R div -> muxout */
}

void ad9510_init(struct wr_rf_device *dev)
{
    gpio_set(dev, DDS_GPIOR_PLL_VCXO_FUNCTION, 0); /* reset AD9510 */
    udelay(10);
    gpio_set(dev, DDS_GPIOR_PLL_VCXO_FUNCTION, 1); /* reset AD9510 */
    udelay(1000);

    ad951x_write_reg(dev, DDS_GPIOR_PLL_VCXO_CS_N, 0, 0x10);

}

int read_adc(struct wr_rf_device *dev, int *buffer, int size)
{
    int n = size;
    while(n--)
    {
	while(rf_readl(dev, DDS_REG_PD_FIFO_CSR) & DDS_PD_FIFO_CSR_EMPTY);

	*buffer++ = rf_readl(dev, DDS_REG_PD_FIFO_R0) & 0xffff;
    }
    return n;
}


void write_tune(struct wr_rf_device *dev, int tune)
{
    while(rf_readl(dev, DDS_REG_TUNE_FIFO_CSR) & DDS_TUNE_FIFO_CSR_FULL);

    rf_writel(dev, tune, DDS_REG_TUNE_FIFO_R0);    
}

void modulation_test(struct wr_rf_device *dev)
{
    rf_writel(dev, 80, DDS_REG_GAIN);    /* tuning gain = 0 dB */
    double f_test = 1e3;
    double f_samp = 125e6/1024.0;
    int n;

    for(;;)
    {
	double x = 32767.0 * cos(2.0*M_PI*(double)n * f_test / f_samp);

//	printf("S %d\n", (int)x);

	write_tune(dev, (int) x);
	n++;
    }
}

int main(int argc, char *argv[])
{
    struct wr_rf_device dev;

    dev.card = spec_open(-1, -1);
    dev.base = 0x80000;

    if(!dev.card)
    {
	dbg("SPEC open failed\n");
	return -1;
    }

    dbg("SDB signature = 0x%x\n", spec_readl(dev.card, 0));

    ad9516_init(&dev);
    reset_core(&dev);
    set_center_freq(&dev, 10e6, 500e6);

//    rf_writel(&dev, DDS_RSTR_SW_RST, DDS_REG_RSTR);
//    sleep(2);
//    rf_writel(&dev, 0, DDS_REG_RSTR);


    adf4002_configure(&dev, 2, 2, 4);

    struct fir_filter *flt_comp = fir_load("fir_compensator.dat");
    struct iir_1st *flt_loop = lowpass_init(0.03);

    rf_writel(&dev, 6000, DDS_REG_GAIN);    /* tuning gain = 0 dB */

//for(;;)    write_tune(&dev, 15000);

//    return 0;    

/*    for(;;)
    {
	int i;
	dbg("up...\n");
	for(i=0;i<1000000;i++)
	    write_tune(&dev, 30000);
	dbg("down...\n");
	for(i=0;i<1000000;i++)
	    write_tune(&dev, -30000);

    }*/

    int i;
    int s;
    for(i=0;i<10000;i++)
	read_adc(&dev, &s , 1);
    
    for(;;)
    {
        int s;
        read_adc(&dev, &s , 1);

	s-=32768;
//	s*=-1;

	s = lowpass_process(flt_loop, s);
	s = fir_process(flt_comp, s);

	s/=25;

//	printf("%d\n", s);

	if(s < -32000) s = -32000;
	else if (s > 32000) s = 32000;
//	s = 30000;
	write_tune(&dev, s);

    }

    modulation_test(&dev);

    spec_close(dev.card);
    return 0;
}

