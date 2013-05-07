#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <getopt.h>
#include <errno.h>

#include "fdelay_lib.h"

#include "sveclib/sveclib.h"
#include "speclib/speclib.h"

#include "fdelay_lib.h"

void printk() {};

static void fd_svec_writel(void *priv, uint32_t data, uint32_t addr)
{
	svec_writel(priv, data, addr);
}

static uint32_t fd_svec_readl(void *priv, uint32_t addr)
{
	return svec_readl(priv, addr);
}

static void fd_spec_writel(void *priv, uint32_t data, uint32_t addr)
{
	spec_writel(priv, data, addr);
}

static uint32_t fd_spec_readl(void *priv, uint32_t addr)
{
	return spec_readl(priv, addr);
}

#if 0
#endif



#define VENDOR_CERN 0xce42
#define DEVICE_FD_CORE 0xf19ede1a
#define DEVICE_VUART 0xe2d13d04

static int probe_svec(fdelay_device_t *dev, const char *location)
{
	uint32_t map_base;
	int slot;
	void *card; 
	uint32_t core_base;

	printf("probe_svec: loc %s\n", location);

	if (!strncmp(location, "svec:", 5)) {
	    sscanf(location+5, "%d,%x,%x", &slot, &map_base, &core_base);
	} else 
	    return -ENODEV;

	card = svec_open(slot);
	svec_set_map_base(card, map_base, 1);
    	if(!card)
	{
		fprintf(stderr,"SVEC probe failed.\n");
		return -1;
	}

	dev->priv_io = card;
	dev->writel = fd_svec_writel;
	dev->readl = fd_svec_readl;
	dev->base_addr = core_base;

	dbg("svec: using slot %d, A32/D32 base: 0x%x, core base 0x%x\n", slot, map_base, core_base);
	return 0;
}


//void loader_low_level() {};

static int probe_spec(fdelay_device_t *dev, const char *location)
{
	uint32_t core_base;
	int slot;

	if (!strncmp(location, "spec:", 5)) {
	    sscanf(location+5, "%d,%x", &slot, &core_base);
	} else 
	    return -ENODEV;

	dev->priv_io = spec_open(slot, -1);

	if(!dev->priv_io)
	{
	 	fprintf(stderr,"Can't map the SPEC @ slot %d\n", slot);
	 	return -1;
	}

	dev->writel = fd_spec_writel;
	dev->readl = fd_spec_readl;
	dev->base_addr = core_base;

	dbg("spec: using slot %d, core base 0x%x\n", slot, core_base);

        return 0;
}

int fdelay_probe(fdelay_device_t *dev, const char *location)
{
    int ret;
    ret = probe_svec(dev, location);

    if(ret != -ENODEV)
	return ret;

    ret = probe_spec(dev, location);

    if(ret != -ENODEV)
	return ret;
}

fdelay_device_t *fdelay_create()
{
	return (fdelay_device_t *) malloc(sizeof(fdelay_device_t));
}
