#ifndef __SPECLIB_H
#define __SPECLIB_H

#include <stdint.h>

/* 'Opens' the SPEC card at PCI bus [bus], device/function [dev].
    Returns a handle to the card or NULL in case of failure. */
void *spec_open(int bus, int dev);

/* Closes the SPEC handle [card] */
void spec_close(void *card);

/* Loads the FPGA bitstream into card [card] from file [filename]. 
   Returns 0 on success. */
int spec_load_bitstream(void *card, const char *filename);

/* Loads the WRC LM32 firmware into card [card] from file [filename]. starting at 
   address [base_addr]. Returns 0 on success. 
   WARNING: using improper base address/FPGA firmware will freeze the computer. */
int spec_load_lm32(void *card, const char *filename, uint32_t base_addr);

/* Raw I/O to BAR4 (Wishbone) */
void spec_writel(void *card, uint32_t data, uint32_t addr);
uint32_t spec_readl(void *card, uint32_t addr);

/* Initializes a virtual UART at base address [base_addr]. */
int spec_vuart_init(void *card, uint32_t base_addr);

/* Virtual uart Rx (VUART->Host) and Tx (Host->VUART) functions */
size_t spec_vuart_rx(void *card, char *buffer, size_t size);
size_t spec_vuart_tx(void *card, char *buffer, size_t size);

#endif
