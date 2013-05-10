#!/bin/bash

wbgen2 -V dds_wb_slave.vhd -H record -p dds_wbgen2_pkg.vhd -K ../dds_regs.vh -s defines -C dds_regs.h -D doc/dds_regs.html dds_wb_slave.wb 
