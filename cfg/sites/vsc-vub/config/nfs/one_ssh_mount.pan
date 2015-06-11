template config/nfs/one_ssh_mount;

## Goal : to mount /var/lib/one/.ssh on all OpenNebula nodes

## The CentOS/RH doc says : "nfslock also has to be started for both the NFS client and server to function properly."
## By default, this service is set to "on" for runlevels 345, so the following lines can be kept commented.
#include 'components/chkconfig/config';
#"/software/components/chkconfig/service" = {
#	tbl = SELF;
#	tbl["nfslock"] = dict("on","");
#	return(tbl);
#};

variable ONE_NFS_SERVER ?= '192.168.10.142';
variable ONE_NFS_EXPORTED_DIR ?= '/var/lib/one/.ssh';
variable ONE_NFS_MOUNTPOINT ?= '/var/lib/one/.ssh';

# The mount point should be owned by oneadmin :
include 'components/dirperm/config';
'/software/components/dirperm/paths' = push(dict(
	'path',    ONE_NFS_MOUNTPOINT,
	'owner',   'oneadmin:oneadmin',
	'perm',    '0700',
	'type',    'd',
	)
);

include 'components/nfs/config';
'/software/components/nfs/mounts' = push(
	dict(
		'device',		ONE_NFS_SERVER + ':' + ONE_NFS_EXPORTED_DIR,
		'mountpoint',	ONE_NFS_MOUNTPOINT,
        'fstype',		'nfs',
        'options',		'soft,intr,rsize=8192,wsize=8192',
	)
);