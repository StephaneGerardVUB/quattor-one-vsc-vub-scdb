# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Alvaro Simon Garcia <Alvaro.SimonGarcia@UGent.be>
#

# 


declaration template components/opennebula/schema;

include 'quattor/schema';
include 'pan/types';

type directory = string with match(SELF,'[^/]+/?$');

type opennebula_db = {
    "backend" : string 
    "server" : string
    "port" : long(0..)
    "user" : string
    "passwd" : string
    "db_name" : string
};

type opennebula_log = {
    "system" : string = 'file' with match (SELF, '^(file|syslog)$')
    "debug_level" : long(0..3) = 3
} = dict();

type opennebula_federation = {
    "mode" : string = 'STANDALONE' with match (SELF, '^(STANDALONE|MASTER|SLAVE)$')
    "zone_id" : long = 0
    "master_oned" : string = ''
} = dict();

type opennebula_im = {
    "executable" : string = 'one_im_ssh'
    "arguments" : string
} = dict();

type opennebula_im_mad_collectd = {
    include opennebula_im
} = dict("executable", 'collectd', "arguments", '-p 4124 -f 5 -t 50 -i 20');

type opennebula_im_mad_kvm = {
    include opennebula_im
} = dict("arguments", '-r 3 -t 15 kvm');

type opennebula_im_mad_xen = {
    include opennebula_im
} = dict("arguments", '-r 3 -t 15 xen4');

type opennebula_im_mad = {
    "collectd" : opennebula_im_mad_collectd
    "kvm" : opennebula_im_mad_kvm
    "xen" : opennebula_im_mad_xen
} = dict();

type opennebula_vm = {
    "executable" : string = 'one_vmm_exec'
    "arguments" : string
    "default" : string
} = dict();

type opennebula_vm_mad_kvm = {
    include opennebula_vm
} = dict("arguments", '-t 15 -r 0 kvm', "default", 'vmm_exec/vmm_exec_kvm.conf');

type opennebula_vm_mad_xen = {
    include opennebula_vm
} = dict("arguments", '-t 15 -r 0 xen4', "default", 'vmm_exec/vmm_exec_xen4.conf');

type opennebula_vm_mad = {
    "kvm" : opennebula_vm_mad_kvm
    "xen" : opennebula_vm_mad_xen
} = dict();

type opennebula_tm_mad = {
    "executable" : string = 'one_tm'
    "arguments" : string = '-t 15 -d dummy,lvm,shared,fs_lvm,qcow2,ssh,vmfs,ceph'
} = dict();

type opennebula_datastore_mad = {
    "executable" : string = 'one_datastore'
    "arguments" : string  = '-t 15 -d dummy,fs,vmfs,lvm,ceph'
} = dict();

type opennebula_hm_mad = {
    "executable" : string = 'one_hm'
} = dict();

type opennebula_auth_mad = {
    "executable" : string = 'one_auth_mad'
    "authn" : string = 'ssh,x509,ldap,server_cipher,server_x509'
} = dict();

type opennebula_tm_mad_conf = {
    "name" : string = "dummy"
    "ln_target" : string = "NONE"
    "clone_target" : string = "SYSTEM"
    "shared" : boolean = true
} = dict();

@documentation{ 
check if a specific type of datastore has the right attributes
}
function is_consistent_datastore = {
    ds = ARGV[0];
    if (ds['ds_mad'] == 'ceph') {
        if (ds['tm_mad'] != 'ceph') {
            error("for a ceph datastore both ds_mad and tm_mad should have value 'ceph'");
            return(false);
        };
        req = list('bridge_list', 'ceph_host', 'ceph_secret', 'ceph_user', 'ceph_user_key', 'pool_name');
        foreach(idx; attr; req) {
            if(!exists(ds[attr])) {
                error(format("Invalid ceph datastore! Expected '%s' ", attr));
                return(false);
            };
        };
    };
    # Checks for other types can be added here
    return(true);
};

@documentation{ 
type for ceph datastore specific attributes. 
ceph_host, ceph_secret, ceph_user, ceph_user_key and pool_name are mandatory 
}
type opennebula_ceph_datastore = {
    "ceph_host"                 ? string[]
    "ceph_secret"               ? type_uuid
    "ceph_user"                 ? string
    "ceph_user_key"             ? string
    "pool_name"                 ? string
    "rbd_format"                ? long(1..2)
};

@documentation{ 
type for vnet ars specific attributes. 
type and size are mandatory 
}
type opennebula_ar = {
    "type"                      : string with match(SELF, "^(IP4|IP6|IP4_6|ETHER)$")
    "ip"                        ? type_ipv4
    "size"                      : long (1..)
    "mac"                       ? type_hwaddr
    "global_prefix"             ? string
    "ula_prefix"                ? string
};

@documentation{ 
type for an opennebula datastore. Defaults to a ceph datastore (ds_mad is ceph)
}
type opennebula_datastore = {
    include opennebula_ceph_datastore
    "name"                      : string
    "bridge_list"               ? string[]  # mandatory for ceph ds, lvm ds, ..
    "datastore_capacity_check"  : boolean = true
    "disk_type"                 : string = 'RBD'
    "ds_mad"                    : string = 'ceph'
    "tm_mad"                    : string = 'ceph'
    "type"                      : string = 'IMAGE_DS'
} with is_consistent_datastore(SELF);

type opennebula_vnet = {
    "name" : string
    "bridge" : string
    "gateway" : type_ipv4
    "dns" : type_ipv4
    "network_mask" : type_ipv4
    "bridge_ovs" ? string
    "vlan" ? boolean
    "vlan_id" ? long(0..4095)
    "ar" ? opennebula_ar
};

type opennebula_user = {
    "ssh_public_key" ? string
    "user" ? string 
    "password" ? string
};

type opennebula_remoteconf_ceph = {
    "pool_name" : string
    "host" : string
    "ceph_user" ? string
    "staging_dir" ? directory = '/var/tmp'
    "rbd_format" ? long(1..2)
    "qemu_img_convert_args" ? string
};

type opennebula_oned = {
    "db" : opennebula_db
    "default_device_prefix" ? string = 'hd'
    "onegate_endpoint" ? string
    "monitoring_interval" : long = 60
    "monitoring_threads" : long = 50
    "scripts_remote_dir" : directory = '/var/tmp/one'
    "log" : opennebula_log
    "federation" : opennebula_federation
    "port" : long = 2633
    "vnc_base_port" : long = 5900
    "network_size" : long = 254
    "mac_prefix" : string = '02:00'
    "datastore_capacity_check" : boolean = true
    "default_image_type" : string = 'OS'
    "default_cdrom_device_prefix" : string = 'hd'
    "session_expiration_time" : long = 900
    "default_umask" : long = 177
    "im_mad" : opennebula_im_mad
    "vm_mad" : opennebula_vm_mad
    "tm_mad" : opennebula_tm_mad
    "datastore_mad" : opennebula_datastore_mad
    "hm_mad" : opennebula_hm_mad
    "auth_mad" : opennebula_auth_mad
    "tm_mad_conf" : opennebula_tm_mad_conf[] = list(
        dict(), 
        dict("name", "lvm", "clone_target", "SELF"), 
        dict("name", "shared"), 
        dict("name", "fs_lvm", "ln_target", "SYSTEM"), 
        dict("name", "qcow2"), 
        dict("name", "ssh", "ln_target", "SYSTEM", "shared", false), 
        dict("name", "vmfs"), 
        dict("name", "ceph", "clone_target", "SELF")
    )
    "vm_restricted_attr" : string[] = list("CONTEXT/FILES", "NIC/MAC", "NIC/VLAN_ID", "NIC/BRIDGE")
    "image_restricted_attr" : string = 'SOURCE'
    "inherit_datastore_attr" : string[] = list("CEPH_HOST", "CEPH_SECRET", "CEPH_USER", 
                                               "RBD_FORMAT", "GLUSTER_HOST", "GLUSTER_VOLUME")
    "inherit_vnet_attr" : string[] = list("VLAN_TAGGED_ID", "BRIDGE_OVS")
};

@documentation{ 
Type that sets the OpenNebula conf
to contact to ONE RPC server
}
type opennebula_rpc = {
    "port" : long(0..) = 2633
    "host" : string = 'localhost'
    "user" : string = 'oneadmin'
    "password" : string
} = dict();

@documentation{
Type that sets the OpenNebula
untouchable resources
}
type opennebula_untouchables = {
    "datastores" ? string[]
    "vnets" ? string[]
    "users" ? string[]
    "hosts" ? string[]
};


@documentation{
Type to define ONE basic resources
datastores, vnets, hosts names, etc
}
type component_opennebula = {
    include structure_component
    'datastores'    : opennebula_datastore[1..]
    'users'         : opennebula_user[]
    'vnets'         : opennebula_vnet[]
    'hosts'         : string[]
    'rpc'           : opennebula_rpc
    'untouchables'  : opennebula_untouchables
    'oned'          : opennebula_oned
    'ssh_multiplex' : boolean = true
    'host_ovs'      ? boolean
    'host_hyp'      : string = 'kvm' with match (SELF, '^(kvm|xen)$')
    'tm_system_ds'  ? string with match(SELF, "^(shared|ssh|vmfs)$")
} = dict();

