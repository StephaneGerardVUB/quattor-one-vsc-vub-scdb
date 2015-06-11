template config/one/infrastructure;

include 'components/opennebula/config';

# list of the one hosts
'/software/components/opennebula/hosts' = list('vscvhost02.wn.iihe.ac.be');

# /etc/one/oned.conf
#'/software/components/opennebula/oned/db' = dict(
#	'backend',	'mysql',
#	'server',	'localhost',
#	'port',		0,
#	'user',		'oneadmin',
#	'passwd',	'my-fancy-pass',
#	'db_name',	'opennebula',
#);
#'/software/components/opennebula/oned/default_device_prefix' = 'vd';
#'/software/components/opennebula/oned/onegate_endpoint' = 'http://hyp004.cubone.os:5030';

# xml-rpc password
#'/software/components/opennebula/rpc/password' = ONE_RPC_PASSWORD;

# users
'/software/components/opennebula/users' = list(
	dict(
		'user',				'lsimngar',
		'password',			'my_fancy_pass',
		'ssh_public_key',	'ssh-dss AAAAB3NzaC1kc3MAAACBAOTAivURhUrg2Zh3DqgVd2ofRYKmXKjWDM4LITQJ/Tr6RBWhufdxmJos/w0BG9jFbPWbUyPn1mbRFx9/2JJjaspJMACiNsQV5KD2a2H/yWVBxNkWVUwmq36JNh0Tvx+ts9Awus9MtJIxUeFdvT433DePqRXx9EtX9WCJ1vMyhwcFAAAAFQDcuA4clpwjiL9E/2CfmTKHPCAxIQAAAIEAnCQBn1/tCoEzI50oKFyF5Lvum/TPxh6BugbOKu18Okvwf6/zpsiUTWhpxaa40S4FLzHFopTklTHoG3JaYHuksdP4ZZl1mPPFhCTk0uFsqfEVlK9El9sQak9vXPIi7Tw/dyylmRSq+3p5cmurjXSI93bJIRv7X4pcZlIAvHWtNAYAAACBAOCkwou/wYp5polMTqkFLx7dnNHG4Je9UC8Oqxn2Gq3uu088AsXwaVD9t8tTzXP1FSUlG0zfDU3BX18Ds11p57GZtBSECAkqH1Q6vMUiWcoIwj4hq+xNq3PFLmCG/QP+5Od5JvpbBKqX9frc1UvOJJ3OKSjgWMx6FfHr8PxqqACw lsimngar@OptiPlex-790'
	)
);

# vnets
'/software/components/opennebula/vnets' = list(
	dict(
		'name',			'Private_T2B',
		'bridge',		'br0',
		'gateway',		'192.168.10.200',
		'dns',			'193.58.172.5',
		'network_mask',	'255.255.0.0',
#		'ar',			dict(
#							'type',		'IP4',
#							'ip',		'192.168.52.1',
#							'size',		100,
#						),
	)
);


# configure datastore
prefix '/software/components/opennebula/datastores/0';
'name' = 'nfs_ds';
#'bridge_list' = list(FULL_HOSTNAME); # for now, do this from the headnode
#'ceph_host' = CEPH_MON_HOSTS;
#'ceph_secret' = CEPH_LIBVIRT_UUID;
#'ceph_user' = 'libvirt';
#'ceph_user_key' = CEPH_LIBVIRT_SECRET;
'datastore_capacity_check' = true;
#'pool_name' = 'one';
'type' = 'IMAGE_DS';
#'rbd_format' = 2;
'disk_type' = 'FILE';
'ds_mad' = 'fs';
'tm_mad' = 'shared';


# untouchables resources
prefix '/software/components/opennebula/untouchables';
'datastores' = list('system');

# extra conf
prefix '/software/components/opennebula';
'ssh_multiplex' = true;
'tm_system_ds' = 'shared';