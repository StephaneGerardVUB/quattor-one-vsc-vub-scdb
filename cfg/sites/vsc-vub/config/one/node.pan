template config/one/node;

# add opennebula repository
# add ceph-extra repository, to get support of ceph in kvm
include 'quattor/functions/repository';
'/software/repositories' = {
	add_repositories( list( 'opennebula_4.12_centos6_x86_64' ), 'repository/snapshot' );
};

# if you want to use a ceph datastore with kvm, you need a special build of kvm...
variable CEPH_DATASTORE ?= true;
'/software/repositories' = if ( CEPH_DATASTORE ) {
	add_repositories( list( 'ceph_extras_centos6_x86_64' ), 'repository/snapshot' );
};
# TODO : here we should add some code to make the ceph-extras repo prioritory over the others
# so that we get the kvm packages from the ceph_extras repo
# As a temp.solution, we've simply added "'priority' = 50;" in the repo template...

# install package opennebula-node-kvm
'/software/packages/{opennebula-node-kvm}' ?= dict();

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

# Datastores must be mounted
include 'config/nfs/one_ds_mount';