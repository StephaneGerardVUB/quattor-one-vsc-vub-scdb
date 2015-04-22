object template profile_vscvhost02.wn.iihe.ac.be;


# To avoid errors with ncm-network during config of eth1 (nic is not configured)
variable NETWORK_PARAMS_DEFAULT ?= dict(
    'bootproto','none',
    'onboot','no',
);


include 'machine-types/simple';


include 'config/one_vsc_cloud';
include 'components/opennebula/config';


# Configure this machine as an OpenNebula frontend
include 'config/one_node';


# software repositories (should be last)
include PKG_REPOSITORY_CONFIG;