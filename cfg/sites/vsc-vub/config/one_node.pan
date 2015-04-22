template config/one_node;

# add opennebula repository
include 'quattor/functions/repository';
'/software/repositories' = {
	add_repositories( list( 'opennebula_4.12_centos_x86_64' ) );
};

# install package opennebula-node-kvm
'/software/packages/{opennebula-node-kvm}' ?= dict();

# TODO : to support ceph datastore, we need a special version of qemu/kvm

# start some services (messagebus, libvirtd, nfs)
include 'components/chkconfig/config';
'/software/components/chkconfig/service/messagebus/off' = null;
'/software/components/chkconfig/service/messagebus/on' = '';
'/software/components/chkconfig/service/libvirtd/on' = '';
'/software/components/chkconfig/service/nfs/on' = '';

# opennebula package creates a oneadmin account -> this must not be removed
# by account component (remember that ncm-account is a pre-dep of ncm-opennebula)
# This should be done in a template components/opennebula/opennebula-user
# (like Kenneth did for the ceph component for example)
include 'components/accounts/config';
'/software/components/accounts/kept_users/oneadmin' = '';
'/software/components/accounts/kept_groups/oneadmin' = '';

# ncm-grud should not be used 
#'/software/components/grub/active' = false;
'/software/components/grub' = null;



# configure the network (creation of bridges)
'/system/network/interfaces/br0' = npush(
	'ip',			DB_IP[escape(FULL_HOSTNAME)],
	'type',			'Bridge',
    'broadcast',	PRIVATE_BROADCAST,
    'gateway',		PRIVATE_GATEWAY,
    'netmask',		PRIVATE_NETMASK,
    'bootproto',	'static',
    'onboot',		'yes',
);
'/system/network/interfaces/eth0' = {
	nlst = SELF;
	nlst['bridge'] = 'br0';
	nlst;
};

# OpenNebula directory that must be shared between the nodes
include 'config/nfs/one_conf_mount';