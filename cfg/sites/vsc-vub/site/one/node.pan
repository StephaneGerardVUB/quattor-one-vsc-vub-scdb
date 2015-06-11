template site/one/node;

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

# OpenNebula /var/lib/one directory that is exported from frontend and mounted on the nodes
#include 'config/nfs/one_conf_mount';

# To share the authorized_keys file of oneadmin
include 'config/nfs/one_ssh_mount';

# Datastores must be mounted
include 'config/nfs/one_ds_mount';