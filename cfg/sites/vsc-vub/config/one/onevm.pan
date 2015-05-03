unique template config/one/onevm;

#From Alvaro's example

# set opennebula map
include 'quattor/aii/opennebula/schema';
bind "/system/opennebula" = opennebula_vmtemplate;

#include 'site/config-vm';
#>>>>Below is the content of site/config-vms from Alvaro's example
# AII opennebula VM conf

# Set network
prefix "/system/opennebula";
"vnet" = dict(
    "eth0", "Private_T2B",
);

# Set storage
"datastore" = dict(
    "vda", "nfs_ds",
);

# set aii opennebula hooks
final variable OPENNEBULA_AII_FORCE = true; 
final variable OPENNEBULA_AII_ONHOLD = false;
#<<<<End of site/config-vms

include 'quattor/aii/opennebula/default';

"/software/packages/{acpid}" = dict();
"/software/components/chkconfig/service/acpid" = dict('on','', 'startstop',true);
