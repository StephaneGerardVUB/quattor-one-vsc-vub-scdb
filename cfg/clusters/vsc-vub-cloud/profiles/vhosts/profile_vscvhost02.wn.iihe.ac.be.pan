object template profile_vscvhost02.wn.iihe.ac.be;


# To avoid errors with ncm-network during config of eth1 (nic is not configured)
variable NETWORK_PARAMS_DEFAULT ?= dict(
    'bootproto','none',
    'onboot','no',
);


include 'machine-types/non-grid/base';


# Configure this machine as an OpenNebula node (hypervizor)
include 'config/one/node';


# software repositories (should be last)
include PKG_REPOSITORY_CONFIG;