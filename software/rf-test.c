#include <stdio.h>

#include "rf-lib.h"
#include "speclib.h"


int main(int argc, char *argv[])
{
    struct wr_rf_device *dev_master, *dev_slave;
    void *card_master, *card_slave;

    card_master = spec_open(1, -1);
    card_slave = spec_open(2, -1);
//    dev.base = 0x80000;

    if(!card_master || !card_slave)
    {
	dbg("SPEC open failed\n");
	return -1;
    }

    dev_master = rf_create(card_master,  0x80000);
    dev_slave = rf_create(card_slave,  0x80000);


    printf("SDB ID A = %x\n", spec_readl(card_master, 0));
    printf("SDB ID B = %x\n", spec_readl(card_slave, 0));

    
    rf_init(dev_slave, 10e6, RF_MODE_SLAVE, 11);
    sleep(10);
    rf_init(dev_master, 10e6, RF_MODE_MASTER, 11);

    struct rf_counters cnt_m, cnt_s;
    for(;;)
    {
	rf_get_counters(dev_master, &cnt_m);
	rf_get_counters(dev_slave, &cnt_s);

        printf("Master cnt: tx %d rx %d hits %d misses %d\n", cnt_m.tx, cnt_m.rx, cnt_m.hit, cnt_m.miss);
        printf("Slave cnt: tx %d rx %d hits %d misses %d\n", cnt_s.tx, cnt_s.rx, cnt_s.hit, cnt_s.miss);
	sleep(1);
    }

    spec_close(card_master);
    spec_close(card_slave);
    return 0;
}

