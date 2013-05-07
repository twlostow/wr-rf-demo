/*
 * This header differentiates between kernel-mode and user-mode compilation,
 * as loader-ll.c is meant to be used in both contexts.
 */

#ifndef __iomem
#define __iomem /* nothing, for user space */
#endif

extern int loader_low_level(
	int fd,			/* This is ignored in kernel space */
	void __iomem *bar4,	/* This is ignored in user space */
	const void *data,
	int size8);




/* Registers from the gennum header files */
enum {
	GNGPIO_BASE = 0xA00,
	GNGPIO_DIRECTION_MODE = GNGPIO_BASE + 0x4,
	GNGPIO_OUTPUT_ENABLE = GNGPIO_BASE + 0x8,
	GNGPIO_OUTPUT_VALUE = GNGPIO_BASE + 0xC,
	GNGPIO_INPUT_VALUE = GNGPIO_BASE + 0x10,

	FCL_BASE	= 0xB00,
	FCL_CTRL	= FCL_BASE,
	FCL_STATUS	= FCL_BASE + 0x4,
	FCL_IODATA_IN	= FCL_BASE + 0x8,
	FCL_IODATA_OUT	= FCL_BASE + 0xC,
	FCL_EN		= FCL_BASE + 0x10,
	FCL_TIMER_0	= FCL_BASE + 0x14,
	FCL_TIMER_1	= FCL_BASE + 0x18,
	FCL_CLK_DIV	= FCL_BASE + 0x1C,
	FCL_IRQ		= FCL_BASE + 0x20,
	FCL_TIMER_CTRL	= FCL_BASE + 0x24,
	FCL_IM		= FCL_BASE + 0x28,
	FCL_TIMER2_0	= FCL_BASE + 0x2C,
	FCL_TIMER2_1	= FCL_BASE + 0x30,
	FCL_DBG_STS	= FCL_BASE + 0x34,
	FCL_FIFO	= 0xE00,
	PCI_SYS_CFG_SYSTEM = 0x800
};



/* The following part implements a different access rule for user and kernel */

#include <stdio.h>
#include <stdint.h>
#include <sys/ioctl.h>
#include <errno.h>

static inline void lll_write(int fd, void __iomem *bar4, uint32_t val, int reg)
{
	*(volatile uint32_t *)(bar4+reg) = val;
}

static inline uint32_t lll_read(int fd, void __iomem *bar4, int reg)
{
	return *(volatile uint32_t *)(bar4 + reg);
}

#define KERN_ERR /* nothing */
#define printk(format, ...) fprintf (stderr, format, ## __VA_ARGS__)

