#!/bin/bash

# This is an example of the bigfish test suite using autoreport. It
# shows how much easier test scripts can become using this feature.
#
# Bigfish reports a bogomips number for your system. This is not really
# a valuable number but is great for demonstrating.
#
MIPS_COUNT=$(grep -i 'bogomips' /var/log/dmesg |tail -1 | perl -e 'my $line = <>; my ($number) = $line =~ m/(\d+(\.\d+)?) BogoMIPS/; print $number;')
if [ -z "$MIPS_COUNT" ] ; then
        TAP[0]='no ok - BogoMIPS from dmesg'
else
        TAP[0]='ok - BogoMIPS from dmesg'
        TAPDATA[0]="BogoMIPS:$MIPS_COUNT" 
fi 

source /data/tapper/autoreport/tapper-autoreport 

