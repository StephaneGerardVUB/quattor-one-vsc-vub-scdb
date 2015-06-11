template features/one_node/config;

include 'features/one_node/rpms/config';

# start some services (messagebus, libvirtd, nfs)
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'messagebus/off' = null;
'messagebus/on' = '';
'libvirtd/on' = '';
'nfs/on' = '';

# opennebula package creates a oneadmin account -> this must NOT be removed by ncm-account
include 'components/accounts/config';
prefix '/software/components/accounts';
'kept_users/oneadmin' = '';
'kept_groups/oneadmin' = '';

# ncm-grud should not be used 
#'/software/components/grub/active' = false;
'/software/components/grub' = null;

# Site specific configurations for one node is included below
include 'site/one/node';
