#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <math.h>

struct fir_filter {
    int n_taps;
    int pos;
    int *delay;
    double *coefs;
};


struct iir_1st {
    int x0;
    double y0, alpha;
};

struct fir_filter * fir_load(const char *coeffs_fname)
{
    FILE * f=fopen(coeffs_fname, "r");
    double coeffs[1024];
    if(!f)
	return NULL;

    int n = 0, i;

    while((fscanf(f, "%lf", &coeffs[n]) == 1) && n < 1024) n++;
	
    printf("Loaded FIR Filter %s: %d taps.\n", coeffs_fname, n);

    struct fir_filter *flt = malloc(sizeof(struct fir_filter));
    flt->delay = malloc(sizeof(int) * n);
    flt->coefs = malloc(sizeof(double) * n);

    memcpy(flt->coefs, coeffs, sizeof(double) * n);

    flt->n_taps = n;
    flt->pos = 0;
    memset(flt->delay, 0, sizeof(int) * n);

    fclose(f);

    return flt;
}

int fir_process(struct fir_filter *flt, int x)
{
    double acc = 0.0;

    flt->delay[flt->pos] = x;

    int i;
    for(i = 0; i< flt->n_taps; i++)
    {
	int idx = flt->pos - flt->n_taps + 1 + i;
	if(idx < 0)
	    idx += flt->n_taps;
	else if (idx >= flt->n_taps)
	    idx -= flt->n_taps;

	acc += flt->coefs[i] * (double)flt->delay[idx];
    }

    flt->pos++;
    if(flt->pos == flt->n_taps)
	flt->pos = 0;
    return (int) acc;
}

struct iir_1st * lowpass_init(double alpha)
{
    struct iir_1st *flt = malloc(sizeof(struct iir_1st));

    flt->alpha = alpha;
    flt->y0 = 0.0;
//    flt->x0 = 0;
    return flt;
}

int lowpass_process(struct iir_1st *flt, int x)
{
    double y = flt->y0 + flt->alpha * ((double) x - flt->y0);

    flt->y0 = y;

    return (int) y;
}
