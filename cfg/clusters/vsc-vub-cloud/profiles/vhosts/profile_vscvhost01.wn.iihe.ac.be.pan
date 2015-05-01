object template profile_vscvhost01.wn.iihe.ac.be;

#DESPITE ITS NAME, THIS MACHINE IS ACTUALLY CONFIGURED AS AN OPENNEBULA FRONT-END
#NORMALLY, IT COULD ALSO PLAY THE ROLE OF NODE.

# To avoid errors with ncm-network during config of eth1 (nic is not configured)
variable NETWORK_PARAMS_DEFAULT ?= dict(
    'bootproto','none',
    'onboot','no',
);


include 'machine-types/non-grid/base';


# Configure this machine as an OpenNebula frontend
include 'config/one/frontend';




# software repositories (should be last)
include PKG_REPOSITORY_CONFIG;