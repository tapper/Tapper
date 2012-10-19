#!/bin/sh

# This is an example of the bigfish test suite. It does everything
# needed for Tapper in shell. If you want to ease Tapper handling in
# shell, have a look at autoreport.
#
# Bigfish reports a bogomips number for your system. This is not really
# a valuable number but is great for demonstrating.
#


gen_output()
{
# tell Tapper how many tests to expect
    echo '1..3'
    
# generate headers to provide additional information in Web GUI
    HOSTNAME=`hostname`
    echo "# Tapper-suite-name: BigFish
# Tapper-suite-version: 1.0
# Tapper-machine-name: $HOSTNAME
# Tapper-section: BogoMIPS overview"

# tell Web GUI which testrun this report belongs to
if [ -n "$TAPPER_TESTRUN"  ]; then
    echo "# Tapper-reportgroup-testrun: $TAPPER_TESTRUN"
fi    

# check for logfile
    if [ ! -e /var/log/messages ]; then
        echo -n 'not '
    fi
    echo 'ok - Logfile exists'
    
# check whether logfile is readable
    if [ ! -r '/var/log/messages' ]; then
        echo -n 'not '
    fi
    echo 'ok - Logfile is readable'
    
    MIPS_COUNT=$(grep -i 'bogomips' /var/log/dmesg |tail -1 | perl -e 'my $line = <>; my ($number) = $line =~ m/(\d+(\.\d+)?) BogoMIPS/; print $number;')
    
    if [ -z "$MIPS_COUNT" ] ; then
        echo -n 'not '
    fi
    echo 'ok - BogoMIPS from dmesg'
    echo '   ---'
    echo "   BogoMIPS: $MIPS_COUNT"
    echo '   ...'
}

if [ -n "$TAPPER_REPORT_SERVER" ];then
    gen_output | netcat $TAPPER_REPORT_SERVER $TAPPER_REPORT_PORT 
else
    gen_output
fi
