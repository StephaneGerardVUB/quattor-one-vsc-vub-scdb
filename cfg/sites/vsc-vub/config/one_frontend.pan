template config/one_frontend;

## Goal : to configure an OpenNebula frontend

# add opennebula and rubygems repositories
include 'quattor/functions/repository';
'/software/repositories' = {
	add_repositories( list( 'opennebula_4.12_centos_x86_64', 'sl6_iihe_rubygems' ) );
};


# install packages : opennebula-sunstone and opennebula-server
'/software/packages/{opennebula-sunstone}' ?= dict();
'/software/packages/{opennebula-server}' ?= dict();

# Uncomment the line below if you are not able to install the ruby gems
# under the form of rpm packages (generated with Alvaro's script).
#include { 'config/one_build_rubygems' };

# /usr/share/one/install_gems
# will install gems under the form of packages generated with this tool :
# https://github.com/OpenNebula/addon-installgems
# (see the sl6_iihe_rubygems added above)
'/software/packages/{rubygem-zendesk_api}' ?= dict();
'/software/packages/{rubygem-treetop}' ?= dict();
'/software/packages/{rubygem-amazon-ec2}' ?= dict();
'/software/packages/{rubygem-aws-sdk}' ?= dict();
'/software/packages/{rubygem-builder}' ?= dict();
'/software/packages/{rubygem-curb}' ?= dict();
'/software/packages/{rubygem-mini_portile}' ?= dict();
'/software/packages/{rubygem-mysql}' ?= dict();
'/software/packages/{rubygem-net-ldap}' ?= dict();
'/software/packages/{rubygem-ox}' ?= dict();
'/software/packages/{rubygem-parse-cron}' ?= dict();
'/software/packages/{rubygem-rack-protection}' ?= dict();
'/software/packages/{rubygem-sqlite3}' ?= dict();
'/software/packages/{rubygem-tilt}' ?= dict();
'/software/packages/{rubygem-trollop}' ?= dict();
'/software/packages/{rubygem-xml-simple}' ?= dict();
'/software/packages/{rubygem-zendesk_api}' ?= dict();

# needed for sunstone to start, though it is not a dependency
'/software/packages/{libxslt}' ?= dict();


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

# OpenNebula directory that must be shared between the nodes
include 'config/nfs/one_conf_export';

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

# change datastore paths in /etc/one/oned.conf
'/software/components/filecopy/services' = npush(
	escape('/root/change_datastore_location.sh'),
	dict(
		'config',	"#!/bin/bash\n sed -i  's|#DATASTORE_LOCATION  = /var/lib/one/datastores|DATASTORE_LOCATION  = /mnt/datastores|' /etc/one/oned.conf\nsed -i  's|#DATASTORE_BASE_PATH = /var/lib/one/datastores|DATASTORE_BASE_PATH = /mnt/datastores|' /etc/one/oned.conf",
		'restart',	'/root/change_datastore_location.sh',
		'owner',	'root:root',
		'perms',	'0755',
	)
);

#NOTE : the 2 commands below have been commented because we finally decided
#		to export /var/lib/one from the frontend.

# Taking care of pre-dependencies of ncm-components :
# dirperm must be launched before nfs because the mount point
# /var/lib/one must be owned by oneadmin:oneadmin, and nfs
# must be done before filecopy because filecopy needs to write
# in the mount /var/lib/one :
#'/software/components/filecopy/dependencies/pre' = { merge( SELF, list( 'nfs' ) ) };
#'/software/components/nfs/dependencies/pre' = { merge( SELF, list( 'dirperm' ) ) };