template features/one_frontend/config;



include 'features/one_frontend/rpms/config';


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

# start oned and sunstone daemons
#include 'components/chkconfig/config';
#'/software/components/chkconfig/service/opennebula/on' = '';
#'/software/components/chkconfig/service/opennebula-sunstone/on' = '';
'/software/components/chkconfig/service/opennebula/off' = '';
'/software/components/chkconfig/service/opennebula-sunstone/off' = '';

# OpenNebula /var/lib/one directory that is exported from frontend and mounted on the nodes
#include 'config/nfs/one_conf_export';

# To share the authorized_keys file of oneadmin
include 'config/nfs/one_ssh_export';

# Mount the datastore which is a NFS share exported from a ZFS fileserver
include 'config/nfs/one_ds_mount';

# configure SSH public key (avoid being prompted to add the keys in known_hosts file)
include 'components/filecopy/config';
variable CONTENTS = <<EOF;
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
'/software/components/filecopy/services' = npush(
	escape('/var/lib/one/.ssh/config'),
	dict(
		'config',	CONTENTS,
		'owner',	'oneadmin:oneadmin',
		'perms',	'0600',
		)
);

# replace ':host: 127.0.0.1' by ':host: 0.0.0.0' in /etc/one/sunstone-server.conf
'/software/components/filecopy/services' = npush(
	escape('/root/unlock_sunstone.sh'),
	dict(
		'config',	"#!/bin/bash\n sed -i  's/:host: 127.0.0.1/:host: 0.0.0.0/' /etc/one/sunstone-server.conf",
		'restart',	'/root/unlock_sunstone.sh',
		'owner',	'root:root',
		'perms',	'0755',
	)
);

## change datastore paths in /etc/one/oned.conf
#'/software/components/filecopy/services' = npush(
#	escape('/root/change_datastore_location.sh'),
#	dict(
#		'config',	"#!/bin/bash\n sed -i  's|#DATASTORE_LOCATION  = /var/lib/one/datastores|DATASTORE_LOCATION  = /mnt/datastores|' /etc/one/oned.conf\nsed -i  's|#DATASTORE_BASE_PATH = /var/lib/one/datastores|DATASTORE_BASE_PATH = /mnt/datastores|' /etc/one/oned.conf",
#		'restart',	'/root/change_datastore_location.sh',
#		'owner',	'root:root',
#		'perms',	'0755',
#	)
#);

#NOTE : the 2 commands below have been commented because we finally decided
#		to export /var/lib/one from the frontend.

# Taking care of pre-dependencies of ncm-components :
# dirperm must be launched before nfs because the mount point
# /var/lib/one must be owned by oneadmin:oneadmin, and nfs
# must be done before filecopy because filecopy needs to write
# in the mount /var/lib/one :
#'/software/components/filecopy/dependencies/pre' = { merge( SELF, list( 'nfs' ) ) };
#'/software/components/nfs/dependencies/pre' = { merge( SELF, list( 'dirperm' ) ) };

# Below include is to define resources that are part on what is called "infrastructure"
# in the sunstone interface : Clusters, Hosts, Datastores, Virtual Networks,...
include 'config/one/infrastructure';



# RPC endpoint
prefix "/software/components/opennebula/rpc";
"user" = "oneadmin";
"password" = ONE_RPC_PASSWORD;
"host" = "localhost";
"port" = 2633;

include 'features/one_frontend/one_auth';