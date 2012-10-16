#! /bin/bash

####################################################
#
# Starter script for Xen
#
# - based on autoreport to report its own success
# - assumes "xl" frontend
# - on SLES 11 SP(1,2) distro-xen it uses xm
#
####################################################

. /virt/tapper-autoreport --import-utils

xlxm=$(which xl)

WE_ARE_ON_SLES11_AUTOINSTALL=0
if grep -q "SUSE Linux Enterprise Server 11 SP" /etc/issue ; then
    if [ -e /root/postinstall.log ] ; then
        WE_ARE_ON_SLES11_AUTOINSTALL=1
        xlxm=$(which xm)
    fi
fi

SUITENAME="$(basename $xlxm)-create-__GUESTNR__-__GUESTNAME__"
DONTREPEATMETA=1
GUESTSTARTUPHOOKDIR=__GUESTSTARTUPHOOKDIR__
IOMMUV2=__IOMMUV2__

guestconfig="/virt/guest-__GUESTNR__.svm"
log="/virt/$SUITENAME.log"
echo "" > $log

[ -x "$xlxm" ]
require_ok $? "$(basename $xlxm) available"

upload_dmesg="/virt/upload-xen-dmesg.sh"
if [ -e $upload_dmesg ] ; then $upload_dmesg ; fi

diag "SLES 11 autoinstall: $WE_ARE_ON_SLES11_AUTOINSTALL"

if [ "x$WE_ARE_ON_SLES11_AUTOINSTALL" == "x0" ] ; then
    echo "/etc/init.d/xend stop" >> $log
    echo "------------------------------------------------------" >> $log
    echo "" >> $log
    /etc/init.d/xend stop >> $log 2>&1
    sleep 10 # grace period
fi

if [ -d "$GUESTSTARTUPHOOKDIR" ] ; then
    (
        cd $GUESTSTARTUPHOOKDIR
        for startupscript in $(ls -1 | grep -v '^tapper-autoreport$' | sort); do
            ./$startupscript
        done
    )
fi

if [[ ${IOMMUV2} == 1 ]]; then
   #enable passthrough mode for gfx
   echo "IOMMUV2: $IOMMUV2" >> $log
   echo "IOMMUV2: enable passthrough mode for gfx" >> $log
   bdf=$(lspci -n | grep "1002:6798" | head -1 | cut -d" " -f1)
   echo "IOMMUV2: $bdf" >> $log

   echo -n 0000:$bdf > /sys/bus/pci/drivers/pciback/new_slot
   echo -n 0000:$bdf > /sys/bus/pci/drivers/pciback/bind

   echo "pci = ['$bdf']" >> $guestconfig
   echo "guest_iommu = 1" >> $guestconfig
fi

# provide meta information to guest
outputdir=$(/virt/autoreport-utils tapper_output_dir)/meta
mkdir -p $outputdir
_name=tapper_all_meta
_meta="$outputdir/$_name.txt"
_info="$outputdir/tapper_setup.txt"
if [ ! -e "$_meta" ] ; then
    SUITENAME=$_name /virt/autoreport-utils $_name > $_meta
fi
if [ ! -e "$_info" ] ; then
    touch $_info
    echo "virtualization: xen"                    >> $_info
    echo "host: __DISTRO__"                       >> $_info
    echo "builder: __BUILDER__"                   >> $_info
    echo "builderchangeset: __BUILDERCHANGESET__" >> $_info
    echo "xenpkg: __XENPKG__"                     >> $_info
    echo "pvops: __PVOPS__"                       >> $_info
    echo "iommuv2: __IOMMUV2__"                   >> $_info
    echo "guestvcpus: __GUESTVCPUS__"             >> $_info
    echo "guestmemory: __GUESTMEMORY__"           >> $_info
fi
echo     "guest-__GUESTNR__: __GUESTNAME__"       >> $_info

echo "" >> $log
echo "" >> $log
echo "*** $xlxm create $guestconfig ***" >> $log
echo "------------------------------------------------------" >> $log
echo "" >> $log
$xlxm create $guestconfig >> $log 2>&1
ok $? "start guest $guestconfig"

. /virt/tapper-autoreport $guestconfig $log
