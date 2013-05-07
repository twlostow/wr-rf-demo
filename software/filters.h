#ifndef __FILTERS_H
#define __FILTERS_H

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

struct fir_filter * fir_load(const char *coeffs_fname);
int fir_process(struct fir_filter *flt, int x);

struct iir_1st * lowpass_init(double alpha);
int lowpass_process(struct iir_1st *flt, int x);


#endif
