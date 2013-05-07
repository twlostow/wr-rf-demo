/*
 * A tool to program our soft-core (LM32) within the SPEC.
 *
 * Alessandro Rubini 2012 for CERN, GPLv2 or later.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <getopt.h>

#include "speclib.h"

int main(int argc, char **argv)
{
	int bus = -1, dev_fn = -1, c;
	uint32_t lm32_base = 0x80000;
	void *card;


	while ((c = getopt (argc, argv, "b:d:c:")) != -1)
	{
		switch(c)
		{
		case 'b':
			sscanf(optarg, "%i", &bus);
			break;
		case 'd':
			sscanf(optarg, "%i", &dev_fn);
			break;
		case 'c':
			sscanf(optarg, "%i", &lm32_base);
			break;
		default:
			fprintf(stderr,
				"Use: \"%s [-b bus] [-d devfn] [-c lm32 base address] <lm32_program.bin>\"\n", argv[0]);
			fprintf(stderr,
				"By default, the first available SPEC is used and the LM32 is assumed at 0x%x.\n", lm32_base);
			exit(1);
		}
	}

	if (optind >= argc) {
		fprintf(stderr, "Expected binary name after options.\n");
		exit(1);
	}
    
    card = spec_open(bus, dev_fn);
	if(!card)
	{
	 	fprintf(stderr, "Can't detect a SPEC card under the given adress. Make sure a SPEC card is present in your PC and the driver is loaded.\n");
	 	exit(1);
	}

	if(spec_load_lm32(card, argv[optind], lm32_base) < 0)
	{
	 	fprintf(stderr, "Loader failure.\n");
	 	exit(1);
	}

	spec_close(card);
	
	exit (0);
}
