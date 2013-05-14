#ifndef __RF_LIB_H
#define __RF_LIB_H

#include <stdint.h>

#define RF_MODE_MASTER 0
#define RF_MODE_SLAVE  1
#define RF_MODE_TEST   2

#define RF_WR_OFFLINE 0
#define RF_WR_SYNCING 1
#define RF_WR_READY 2

struct rf_counters {
    int miss, hit, rx,tx;
};

struct wr_rf_device;

struct wr_rf_device *rf_create(void *handle, uint32_t base_addr);

int rf_init(struct wr_rf_device *dev, double freq, int mode, int bcid);
int rf_search_streams(struct wr_rf_device *dev, int *bcids, int *max_bcids);
int rf_poll_histogram(struct wr_rf_device *dev, int *bcids, int *max_bcids);
int rf_init_histogram(struct wr_rf_device *dev, double bias, double scale);
int rf_read_histogram(struct wr_rf_device *dev, int *hist, int *size);
int rf_get_wr_state(struct wr_rf_device *dev);
int rf_get_counters(struct wr_rf_device *dev, struct rf_counters *);

#endif

