/*
 * Trivial library function to return one of the spec memory addresses
 */
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <errno.h>
#include <sys/signal.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

#include "speclib.h"
#include "wb_uart.h"

#define BASE_BAR0 0
#define BASE_BAR4 4


struct spec_private {
    void *bar0;
    void *bar4;
    uint32_t vuart_base;
};


/* Checks if there's a SPEC card at bus/def_fn. If one (or both) parameters are < 0, takes first available card and returns 0.
   If no cards have been detected, returns -1 */
static int spec_scan(int *bus, int *devfn)
{
	struct dirent **namelist;
	int n, found = 0;
	int my_bus, my_devfn;

	n = scandir("/sys/bus/pci/drivers/spec", &namelist, 0, 0);
	if (n < 0)
	{
		perror("can't find driver at /sys/bus/pci/drivers/spec = scandir");
		return -1;
		//exit(-1);
	} else {
		while (n--) 
		{
			if(!found && sscanf(namelist[n]->d_name, "0000:%02x:%02x.0", &my_bus, &my_devfn) == 2)
			{
				if(*bus < 0) *bus = my_bus;
				if(*devfn < 0) *devfn = my_devfn;
				if(*bus == my_bus && *devfn == my_devfn)
					found = 1;
			}
			free(namelist[n]);
		}
		free(namelist);
	}
        
	if(!found)
	{
		fprintf(stderr,"Can't detect any SPEC card :(\n");
		return -1;
	}
        
	return 0;
	
}

/* Maps a particular BAR of given SPEC card and returns its virtual address 
   (or NULL in case of failure) */

static void *spec_map_area(int bus, int dev, int bar, size_t size)
{
	char path[1024];
	int fd;
	void *ptr;

 	snprintf(path, sizeof(path), "/sys/bus/pci/drivers/spec/0000:%02x:%02x.0/resource%d", bus, dev, bar);
    
	fd = open(path, O_RDWR | O_SYNC);
	if(fd <= 0)
		return NULL;

	ptr = mmap(NULL, size & ~(getpagesize()-1), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    
	if((int)ptr == -1)
	{
		close(fd);
		return NULL;
	}
    
	return ptr;
}

void *spec_open(int bus, int dev)
{
	struct spec_private *card = malloc(sizeof(struct spec_private));

	if(!card || spec_scan(&bus, &dev) < 0)
		return NULL;
	
	card->bar0 = spec_map_area(bus, dev, BASE_BAR0, 0x100000);
	card->bar4 = spec_map_area(bus, dev, BASE_BAR4, 0x1000);
	
	return card;
}

void spec_close(void *card)
{
    struct spec_private *p = (struct spec_private *) card;

	if(!card)
		return;
    munmap(p->bar0, 0x100000);
    munmap(p->bar4, 0x1000);
    free(card);
}

void spec_writel(void *card, uint32_t data, uint32_t addr)
{
//    printf("Writel %x %x\n", addr, data);

    struct spec_private *p = (struct spec_private *) card;
    *(volatile uint32_t *) (p->bar0 + addr) = data;
}

uint32_t spec_readl(void *card, uint32_t addr)
{
//    printf("Readl %x\n", addr);
    struct spec_private *p = (struct spec_private *) card;
    return *(volatile uint32_t *) (p->bar0 + addr);
}

static int vuart_rx(void *card)
{
    struct spec_private *p = (struct spec_private *) card;
    int rdr = spec_readl(card, p->vuart_base + UART_REG_HOST_RDR);
    if(rdr & UART_HOST_RDR_RDY)
	return UART_HOST_RDR_DATA_R(rdr);
	    else
	return -1;
}

static void vuart_tx(void *card, int c)
{
    struct spec_private *p = (struct spec_private *) card;
	while( spec_readl(card, p->vuart_base + UART_REG_SR) & UART_SR_RX_RDY);
	spec_writel(card, UART_HOST_TDR_DATA_W(c), p->vuart_base + UART_REG_HOST_TDR);
}

static char *load_binary_file(const char *filename, size_t *size)
{
	int i;
	struct stat stbuf;
	char *buf;
	FILE *f;

	f = fopen(filename, "r");
	if (!f) 
		return NULL;

	if (fstat(fileno(f), &stbuf))
	{
		fclose(f);
		return NULL;
	}

	if (!S_ISREG(stbuf.st_mode))
	{
		fclose(f);
		return NULL;
	}

	buf = malloc(stbuf.st_size);
	if (!buf) 
	{
		fclose(f);
		return NULL;
    }
    
	i = fread(buf, 1, stbuf.st_size, f);
	if (i < 0) {
		fclose(f);
		free(buf);
		return NULL;
	}
	if (i != stbuf.st_size) {
		fclose(f);
		free(buf);
		return NULL;
	}

	fclose(f);
	*size = stbuf.st_size;
	return buf;
}

int spec_load_bitstream(void *card, const char *filename)
{
    struct spec_private *p = (struct spec_private *) card;
	char *buf;
	size_t size;
	
//	printf("load-bitstream: %s\n", filename);
	buf = load_binary_file(filename, &size);
	if(!buf)
		return -1;
	
	int rv = loader_low_level(0, p->bar4, buf, size);

	free(buf);
	return rv;
}

int spec_load_lm32(void *card, const char *filename, uint32_t base_addr)
{
	char *buf;
	uint32_t *ibuf;
	size_t size;
	int i;
	
	buf = load_binary_file(filename, &size);
	if(!buf)
		return -1;

	/* Phew... we are there, finally */
	spec_writel(card, 0x1deadbee, base_addr + 0x20400);
	while ( ! (spec_readl(card, base_addr + 0x20400) & (1<<28)) );

	ibuf = (uint32_t *) buf;
	for (i = 0; i < (size + 3) / 4; i++) 
		spec_writel(card, htonl(ibuf[i]), base_addr + i*4);

	sync();

	for (i = 0; i < (size + 3) / 4; i++) {
		uint32_t r = spec_readl(card, base_addr + i * 4);
		if (r != htonl(ibuf[i]))
		{
			fprintf(stderr, "programming error at %x "
				"(expected %08x, found %08x)\n", i*4,
				htonl(ibuf[i]), r);
			return -1;
		}
	}

	sync();

	spec_writel(card, 0x0deadbee, base_addr + 0x20400);
	return 0;
}

int spec_vuart_init(void *card, uint32_t base_addr)
{
	struct spec_private *p = (struct spec_private *) card;
	p->vuart_base = base_addr;
	return 0;
}

size_t spec_vuart_rx(void *card, char *buffer, size_t size)
{
	size_t s = size, n_rx = 0;
	while(s--)
	{
		int c =  vuart_rx(card);
		if(c < 0)
			return n_rx;
		*buffer++ = c;
		n_rx ++;
	}
	return n_rx;
}

size_t spec_vuart_tx(void *card, char *buffer, size_t size)
{
	size_t s = size;
	while(s--)
		vuart_tx(card, *buffer++);
	
	return size;
}

