#include <math.h>
#include <stdint.h>
#include <stdio.h>

#define LUT_SIZE_LOG2 10
#define LUT_SIZE (1<<LUT_SIZE_LOG2)

#define ACC_FRAC_BITS 32
#define ACC_BITS (ACC_FRAC_BITS + LUT_SIZE_LOG2 + 2)

#define SLOPE_BITS 18
#define SLOPE_SHIFT 7
#define LUT_BITS 18
#define LUT_AMPL ((1ULL<<(LUT_BITS-1))-(1<<12))

struct lut_entry {
	int value;
	int slope;
} lut [LUT_SIZE];

struct dds_state {
	uint64_t acc;
	uint64_t delta;
};

int dds_update(struct dds_state *s)
{
	int rv;

	int frac;
	int quad;
	int index;
	
	index = (s->acc >> (ACC_FRAC_BITS)) & ((1 << LUT_SIZE_LOG2) - 1);
	quad = (s->acc >> (ACC_FRAC_BITS + LUT_SIZE_LOG2)) & 1;
	frac = (s->acc >> (ACC_FRAC_BITS - SLOPE_BITS)) & ((1ULL << SLOPE_BITS) - 1);
	
	struct lut_entry e;
	int sign = 1;
	
//	printf("quad %d index %d \n", quad,index);
	switch(quad)
	{
		case 0:
			sign = 1;
			break;
		case 1:
			sign = -1;
			break;
	}

	e=lut[index];


	int adj = ((int64_t)e.slope * (int64_t)frac) >>	(SLOPE_BITS + SLOPE_SHIFT);
	printf("idx %d l %d slope %d frac %d adj %d\n", index, e.value, e.slope, frac, adj);

	int dither_bits = 7;

//	printf("f %d %d %d\n", frac, e.slope, adj);		

	int v0 = ((((e.value + adj )* sign))); // + (random()&(1<<dither_bits)-1)) << 1) + 1;

	printf("v0 %d\n", v0);

	v0 >>= 1;

	int vb = v0 & (1<<(dither_bits-1));
	
	v0 >>= (dither_bits - 1);
	if(vb) v0 ++;
	

//	printf("v %d adj %d\n", v0, adj);

	s->acc += s->delta;
	s->acc &= ((1ULL << ACC_BITS) - 1ULL);

	return v0;
}

void calc_lut()
{
	int i,p;
	
	for(i=0;i<LUT_SIZE;i++)
	{
		double x0 = M_PI*((double)i/LUT_SIZE);
		double x1 = M_PI*((double)(i+1)/LUT_SIZE);
		double y0 = (double) LUT_AMPL * sin(x0);
		double y1 = (double) LUT_AMPL * sin(x1);
		
		double slope = (y1-y0) * (double)(1<<SLOPE_SHIFT);
		
	//	printf("v %.3f [%d] slope %.3f [%d] %d\n", y0, (int)y0, slope, (int)slope );
		
		lut[i].value = (int) y0;
		lut[i].slope = (int)slope;
		p=lut[i].value;
		
//		printf("lut[%d]=36'h%llx;\n",i, (uint64_t) (lut[i].value & 0x3ffff) | (((uint64_t)lut[i].slope & 0x3ffff) << 18));
	}

}

void dds_init(struct dds_state *dds, double freq, double fs)
{
	dds->acc = 0;
	dds->delta = (uint64_t) (((double)LUT_SIZE * freq/fs) * (double)(1ULL << ACC_FRAC_BITS));
	dds->delta = 100000000000ULL;
}


main()
{
	struct dds_state dds;

	calc_lut();
	dds_init(&dds, 11.1111e6, 500e6);	
	
	int i;
	
	for(i=0;i<262144;i++)
	{
		printf("", dds_update(&dds));
	}
	
}
