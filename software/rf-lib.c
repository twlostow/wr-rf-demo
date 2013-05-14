#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/time.h>
#include <math.h>

#include "speclib.h"
#include "regs/dds_regs.h"
#include "filters.h"
#include "rf-lib.h"

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


int gp_pos = 0;
int pll_init = 0;
int gp_seq = 0x7;

static void gpio_set(struct wr_rf_device *dev, uint32_t pin, int value)
{
    uint32_t g = rf_readl(dev, DDS_REG_GPIOR);
    if(value)
	rf_writel(dev, g | pin, DDS_REG_GPIOR);
    else
	rf_writel(dev, g & ~pin, DDS_REG_GPIOR);


    if(pll_init)
    {

    int bit;

    if(pin == DDS_GPIOR_PLL_SCLK)
	bit = 1;
    else if(pin == DDS_GPIOR_PLL_SDIO)
	bit = 2;
    else if(pin == DDS_GPIOR_PLL_SYS_CS_N)
	bit = 0;

    int gp_seq_prev = gp_seq;
    if(value)
	gp_seq |= (1<<bit);
    else
	gp_seq &= ~(1<<bit);



	if(gp_seq_prev!=gp_seq)
	    printf("pll_init_seq[%d] = 3'h%x;\n", gp_pos++, gp_seq);
    }

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

    pll_init = 1;

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

    pll_init = 0;
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
    adf4002_write(dev, 2 | (7<<15) | (7<<18) | (0<<7) | ( mon_output << 4)); /* R div -> muxout */
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


void boot_mdsp(struct wr_rf_device *dev, const char *mc_file)
{
    FILE *f=fopen(mc_file,"r");

    uint64_t code[1024],opc;
    int n = 0, i;

    while(fscanf(f, "0x%llx\n", &opc) > 0)
    {
	code[n] = opc;
	n++;
    }

    fclose(f);


    rf_writel(dev, 1, 0x4000); // reset MDSP

    for(i=0;i<n;i++)
    {
	rf_writel(dev, (code[i]>>32), 0x4000+(i*8 + 4) | (1<<11));
        rf_writel(dev, (code[i]>>0), 0x4000+(i*8)  | (1<<11));
    }

    rf_writel(dev, 0, 0x4000); // reset MDSP
             
}

struct wr_rf_device *rf_create(void *handle, uint32_t base_addr)
{
    struct wr_rf_device *dev;
    dev = malloc(sizeof(struct wr_rf_device));

    dev->card = handle;
    dev->base = base_addr;
    return dev;
}

int rf_init(struct wr_rf_device *dev, double freq, int mode, int bcid)
{
    dbg("SDB signature = 0x%x\n", spec_readl(dev->card, 0));

    rf_writel(dev, 0, DDS_REG_CR);

//    ad9516_init(dev);
    reset_core(dev);

    spec_load_lm32(dev->card, "/home/user/wrc-test.bin", 0xc0000);

    sleep(1);

    set_center_freq(dev, freq, 500e6);
    adf4002_configure(dev, 2, 2, 4);

    rf_writel(dev, 3000, DDS_REG_GAIN);   

//08:00:30:61:86:89 
    rf_writel(dev, 0x0800, DDS_REG_MACH);
    rf_writel(dev, 0x30618689, DDS_REG_MACL);

    printf("MAC:%04x%08x\n", rf_readl(dev, DDS_REG_MACH), rf_readl(dev, DDS_REG_MACL));

    if(mode == RF_MODE_MASTER)
    {

        double kp = 0.05;
        double ki = 0.0000005;

        int ki_q = (int) ((1024.0 * ki) * (double)(1<<16));
        int kp_q = (int) ((1.0 * kp) * (double)(1<<16));

//        dbg("kp_q %d ki_q %d\n", kp_q, ki_q);
        rf_writel(dev, DDS_PIR_KI_W(ki_q) | DDS_PIR_KP_W(kp_q), DDS_REG_PIR);

        rf_writel(dev, DDS_CR_MASTER | DDS_CR_CLK_ID_W(bcid), DDS_REG_CR) ;


//	dbg("master mode %d\n", rf_readl(dev, DDS_REG_CR) & DDS_CR_MASTER?1:0);
	return 0;

    } else if (mode == RF_MODE_SLAVE) {
        rf_writel(dev, DDS_RSTR_SW_RST, DDS_REG_RSTR);
	udelay(10);
        rf_writel(dev, 0, DDS_REG_RSTR);
	rf_writel(dev, 10000, DDS_REG_DLYR);    
        rf_writel(dev, DDS_CR_CLK_ID_W(bcid) | DDS_CR_SLAVE, DDS_REG_CR) ;
    

    }
    return 0;
}


int rf_get_counters(struct wr_rf_device *dev, struct rf_counters *cnt)
{
    cnt->hit = rf_readl(dev, DDS_REG_HIT_CNT) & 0xffffff;
    cnt->miss = rf_readl(dev, DDS_REG_MISS_CNT) & 0xffffff;
    cnt->rx = rf_readl(dev, DDS_REG_RX_CNT) & 0xffffff;
    cnt->tx = rf_readl(dev, DDS_REG_TX_CNT) & 0xffffff;
    return 0;
}

#if 0


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
    struct iir_1st *flt_loop = lowpass_init(0.02);


//    test_pid(&dev);
//    test_pid2(&dev);


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

    rf_writel(&dev, 3000, DDS_REG_GAIN);    /* tuning gain = 0 dB */
    rf_writel(&dev, DDS_CR_TEST, DDS_REG_CR);
//    rf_writel(dev, 2000, DDS_REG_GAIN);    /* tuning gain = 0 dB */

    double kp = 0.05;
    double ki = 0.0000005;

    int ki_q = (int) ((1024.0 * ki) * (double)(1<<16));
    int kp_q = (int) ((1.0 * kp) * (double)(1<<16));

    printf("kp_q %d ki_q %d\n", kp_q, ki_q);

//    boot_mdsp(&dev, "microcode.dat");
    rf_writel(&dev, DDS_RSTR_SW_RST, DDS_REG_RSTR);
    udelay(10);
    rf_writel(&dev, 0, DDS_REG_RSTR);
    rf_writel(&dev, DDS_PIR_KI_W(ki_q) | DDS_PIR_KP_W(kp_q), DDS_REG_PIR);
    rf_writel(&dev, DDS_CR_MASTER, DDS_REG_CR);


    return 0;

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

	s/=24;

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


#endif