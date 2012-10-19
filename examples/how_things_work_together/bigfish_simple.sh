#!/bin/sh

# tell Artemis how many tests to expect
echo '1..3'

# generate headers to provide additional information in Web GUI
HOSTNAME=`hostname`
echo "# Artemis-suite-name: BigFish
# Artemis-suite-version: 1.0
# Artemis-machine-name: $HOSTNAME
# Artemis-section: BogoMIPS overview"

# tell Web GUI which testrun this report belongs to
if [ -n "$ARTEMIS_TESTRUN"  ]; then
    echo "# Artemis-reportgroup-testrun: $ARTEMIS_TESTRUN"
fi    

# check for logfile
if [ ! -e /var/log/messages ]; then
    echo -n 'not '
fi
echo 'ok - Logfile exists'

# check whether logfile is readable
if [ ! -r /var/log/messages ]; then
    echo -n 'not '
fi
echo 'ok - Logfile is readable'

MIPS_COUNT=`dmesg |  grep  'Calibrating delay using timer specific routine'|tail -1 | perl -e 'my $line = <>; my ($number) = $line =~ m/(\d+(\.\d+)?) BogoMIPS/; print $number;'`

if [ -z "$MIPS_COUNT" ] ; then
    echo -n 'not '
fi
echo 'ok - BogoMIPS from dmesg'
echo '   ---'
echo "   BogoMIPS: $MIPS_COUNT"
echo '   ...'

