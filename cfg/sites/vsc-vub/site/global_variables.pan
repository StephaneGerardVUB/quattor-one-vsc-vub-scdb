#################################################################################
# 
# If you adopt this template, you don't need these anymore :
#     begrid/site/config
#     begrid/site/defaults
#     iihe-production/site/cluster_info
#     iihe-production/config/glite_base
#     begrid/site/network_private_route
#     iihe-production/config/network_extra_routes_tmp
#     iihe-production/config/network_extra_routes
#
# In this template, you should do nothing else than defining variables !
# Please keep this template clean !
# Put your variables in the dedicated place !
#
#################################################################################
unique template site/global_variables;

include 'pan/functions';


####################################################################
####### VARIOUS                                              #######
####################################################################

# E-mail variables
variable ADMIN_MAIL = 'grid_admin@listserv.vub.ac.be';
variable SMTP_GATEWAY = 'mxin.vub.ac.be';
## string used to identify workernodes
variable WORKER_NODE_REGEXP ?= '^node';
variable NTP_SERVERS ?= list('time.belnet.be');
variable NFS_DEFAULT_MOUNT_OPTTIONS = 'rw,rsize=32768,wsize=1024,async,noatime';


####################################################################
####### OS                                                   #######
####################################################################

variable OS_FLAVOUR_ENABLED = true;
#
# OS version definition
#
variable NODE_OS_VERSION_DB ?= 'site/os_version_db';
variable NODE_OS_VERSION_DEFAULT ?= 'CONFIGURE/MACHINE';
variable OS_BASE_CONFIG_SITE ?= 'config/os_base';

####################################################################
####### REPOSITORIES                                         #######
####################################################################

### To point to the right repo templates
variable SECURITY_CA_RPM_REPOSITORY = 'repository/snapshot/ca';
variable CVMFS_RPM_REPOSITORIES = list('cvmfs');
variable YUM_SNAPSHOT_DATE = '20140313';#even if we at IIHE use REPO_YUM_SNAPSHOT_DATE instead, this variable must be defined because of repository/config/grid

### Repository snapshots in use
variable REPO_YUM_SNAPSHOT_DATE = dict(
	'sl6_addons',					'20140313',
	'sl6_epel',						'1428668577',
	'sl6_t2b',						'1430320749',
	'sl6x_x86_64',					'1424267722',
	'sl6x_x86_64_updates',			'1424189921',
	'sl6x_x86_64_errata',			'1424189376',
	'sl6_iihe_rubygems',			'1429733818',
	'one412_centos6_x86_64',		'1429736006',
	'ceph_extras_centos6_x86_64',	'1429863067',
);

####################################################################
####### NETWORK                                              #######
####################################################################

variable DEFAULT_DOMAIN = 'iihe.ac.be';
variable HOSTNAME = hostname_from_object();
variable DOMAIN = domain_from_object(DEFAULT_DOMAIN);
variable FULL_HOSTNAME= full_hostname_from_object(DEFAULT_DOMAIN);

# Define the nameservers to use for the site.
variable NAMESERVERS = list('193.58.172.5','193.58.172.6','193.190.247.140','193.190.247.71','134.184.15.13','193.190.198.10');

variable PUBLIC_GATEWAY = '193.58.172.2';
variable PUBLIC_NETMASK = '255.255.255.128';
variable PUBLIC_BROADCAST = '193.58.172.127';
variable PRIVATE_GATEWAY = '192.168.10.200';
variable PRIVATE_BROADCAST = '192.168.255.255';
variable PRIVATE_NETMASK = '255.255.0.0';
# The private nameserver is now : ns10.wn.iihe.ac.be
variable PRIVATE_NAMESERVER = '192.168.10.154';

variable PRIVATE_DOMAIN_NAME ?= 'wn.';
variable PRIVATE_DOMAIN = PRIVATE_DOMAIN_NAME + DEFAULT_DOMAIN;
variable PRIVATE_DOMAIN_BOOLEAN ?= {
	if (match(FULL_HOSTNAME,PRIVATE_DOMAIN)) {
		return(true);
	} else {
		return(false);
	};
};

# NETWORK_PARAMS_BOOT contains parameters for the boot_nic (in T2B : always the private).
variable NETWORK_PARAMS_BOOT ?= dict(
	'ip',			DB_IP[escape(FULL_HOSTNAME)],
    'broadcast',	PRIVATE_BROADCAST,
    'gateway',		PRIVATE_GATEWAY,
    'netmask',		PRIVATE_NETMASK
);

# NETWORK_PARAMS_DEFAULT contains default parameters for nic's other than the boot.
variable NETWORK_PARAMS_DEFAULT ?= dict(
    'bootproto','static',
    'onboot','yes',
);


# If set to true, network config will be done by template os/network/config (standard)
variable OS_BASE_CONFIGURE_NETWORK = false;

# Thanks to the static routes, traffic stays in the private network when possible.
# Example : a wn need to contact a behar, they can communicate through
# the private network. Here, we define the list of destinations for
# which it is needed to define a static route via the private network.
variable DIRECT_ROUTES_DEST = list(
	'maite',
	#'m0', 'm1', 'm3', 'm2', 'm6', 'm7', 'm8', 'm9',
	#'mtop',
	'mon', 'egon', 'frontier','frontier2',
	'behar030','behar031','behar032','behar033','behar034','behar035','behar036',
	'behar040','behar041',
	'behar050','behar051','behar052','behar053',
	'behar060','behar064',
	'behar061','behar063','behar062',
	'behar070','behar071','behar072',
	'behar080','behar081','behar082',
	#'cream02',
);

####################################################################
####### QUATTOR                                              #######
####################################################################

# AII site specific configuration

# Name of os repository server used by PXE installation
variable AII_OSINSTALL_SRV ?= 'aiisrv.wn.iihe.ac.be';

# Name of tftp server used by PXE installation
# Defaults to AII_OSINSTALL_SRV.
# variable AII_KS_SRV ?= 'qclig.wn.iihe.ac.be';

# Host part of URL of cgi used to switch to local disk boot.
# Defaults to AII_OSINSTALL_SRV.
# variable AII_ACK_SRV ?= 'qclig.wn.iihe.ac.be';

# Top part of the URL where to dowload OS distribution from
# OS version + /base will be added by default (/base can be change by
# defining AII_OSINSTALL_SUBURL variable
variable AII_OSINSTALL_ROOT ?= '/begrid/install';
variable AII_OSINSTALL_SUBURL ?= '';

## place to get profiles
variable QUATTOR_PROFILE_NAME ?= 'profile_'+FULL_HOSTNAME+'.xml';
variable QUATTOR_PROFILE_URL ?= 'https://' + AII_OSINSTALL_SRV + ':444/profiles';

# spma proxy location
variable USE_SPMA_PROXY ?= true;
variable SPMA_PROXY_SERVER ?= 'qrproxy.wn.iihe.ac.be';

'/software/components/spma/' = {
    t = SELF;
    if (USE_SPMA_PROXY) {
        t['proxy'] = 'yes';
        t['proxytype'] = 'reverse';
        t['proxyhost'] = SPMA_PROXY_SERVER;
        t['proxyport'] = '80';
    };
    t;
};

variable AII_OSINSTALL_DISABLE_SERVICE ?= list('yum','apt','yum-autoupdate');
variable AII_OSINSTALL_BOOTPROTO ?= 'static';

variable AII_DOMAIN ?= DOMAIN;


####################################################################
####### FREEIPA                                              #######
####################################################################

# We only use FREEIPA as of Quattor 14.8.0
variable USE_FREEIPA = true;
variable FREEIPA_AII_USE_NSS ?= true;
variable FREEIPA_AII_DOMAIN ?= 'wn.iihe.ac.be';
variable FREEIPA_AII_SERVER ?= 'freeipa.wn.iihe.ac.be';
variable FREEIPA_AII_REALM ?= 'WN.IIHE.AC.BE';

####################################################################
####### GRID                                                 #######
####################################################################

## GRID site variables
variable WN_CONFIG_SITE ?= 'config/wn';
variable UI_CONFIG_SITE ?= 'config/ui';
variable USER_CONFIG_SITE = 'users/config';

variable VO_SW_AREAS_USE_SWMGR ?= true;
variable VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP ?= false;



####################################################################
####### MONITORING                                           #######
####################################################################

# Ganglia variables
#variable MONITORING_CONFIG_SITE = 'config/ganglia-client';
## name of ganglia config template
variable GANGLIA_SITE_CONFIG ?= 'config/ganglia';

# Deploy pakiti on all machines
variable PAKITI_CLIENT_CONF = '/etc/pakiti/pakiti2-client.conf';
variable PAKITI_ENABLED = false;
variable PAKITI_SERVER = 'pakiti.iihe.ac.be';



####################################################################
####### FILESYSTEM                                           #######
####################################################################

variable FILESYSTEM_CONFIG_SITE ?= 'config/filesystems';

####################################################################
####### VARIOUS : TEMPLATES                                  #######
####################################################################

variable LCG2_BASE_CONFIG_SITE ?= 'site/config_site';
variable GLITE_SITE_PARAMS ?= 'site/grid';
#variable GLITE_BASE_CONFIG_SITE ?= 'config/glite_base';

variable BASE_SITE_FUNCTIONS ?= 'site/functions';
variable BASE_SITE_NAMED_CONFIG ?= 'site/named';