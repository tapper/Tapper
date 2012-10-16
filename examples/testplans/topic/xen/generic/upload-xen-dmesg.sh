#! /bin/bash

####################################################
# Upload Xen dmesg
####################################################

. /virt/tapper-autoreport --import-utils

DONTREPEATMETA=1

xl=$(which xl)
require_ok $? "xl available"

# upload dmesg shortly after start, but only once
xendmesglog="/virt/xen-dmesg.log"
if [ ! -e $xendmesglog ] ; then
    $xl dmesg > $xendmesglog
    . /virt/tapper-autoreport $xendmesglog
fi

# silent exit, we are not a PRC visible testscript anyway
