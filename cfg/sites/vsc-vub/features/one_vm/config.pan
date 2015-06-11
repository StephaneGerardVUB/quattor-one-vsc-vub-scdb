template features/one_vm/config;

include 'features/one_vm/rpms/config';

# set opennebula map
include 'quattor/aii/opennebula/schema';
bind "/system/opennebula" = opennebula_vmtemplate;

# site specific configuration of the VMs
include 'site/config-vm';

include 'quattor/aii/opennebula/default';


"/software/components/chkconfig/service/acpid" = dict('on','', 'startstop',true);
