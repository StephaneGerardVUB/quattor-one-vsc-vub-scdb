template config/nfs/one_conf_export;

## Goal : export the /var/lib/one directory of the OpenNebula frontend

# list of one nodes
variable VSC_CLOUD_NODES = list( '192.168.10.143', '192.168.10.144', '192.168.10.145', '192.168.10.146', '192.168.10.147', '192.168.10.148', '192.168.10.149' );

# nfs export options
variable VSC_CLOUD_OPTIONS = 'rw,sync,no_subtree_check,no_root_squash';

# building the dict of nfs client hosts (key = host, value = options)
variable VSC_CLOUD_HOSTS_OPTS = {
	nlst = dict();
	foreach (idx;val;VSC_CLOUD_NODES) {
		nlst[escape(val)] = VSC_CLOUD_OPTIONS;
	};
	nlst;
};

# configure nfs export of /var/lib/one
include 'components/nfs/config';
'/software/components/nfs/exports' = push(
	dict(
		'path',			'/var/lib/one',
		'hosts',		VSC_CLOUD_HOSTS_OPTS,
	)
);

# make sure nfs service is running
'/software/packages/{nfs-utils}' = dict();
'/software/components/chkconfig/service' = {
	SELF['nfs'] = dict( 'on', '', 'startstop', true );
	SELF['nfslock'] = dict( 'on', '', 'startstop', true );
	SELF;
};