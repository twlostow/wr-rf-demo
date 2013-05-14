#!/bin/bash
insmod /home/user/pts/test/fmcdelay1ns4cha/lib/spec/kernel/spec.ko 
spec-fwloader -b 1 /home/user/rf55-wr.bin
spec-fwloader -b 2 /home/user/rf55-wr.bin
sleep 1
./rf-test
#spec-fwloader /home/user/rf45-wr.bin

