
template site/config;

include 'quattor/functions/filesystem';

## private key and passwords
include 'private/pub_key';
include 'private/passwd';

## ssh
include 'config/ssh';



# ntpd
# ----------------------------------------------------------------------------
include 'components/ntpd/config';



'/software/components/ntpd/servers' = NTP_SERVERS;

# chkconfig
# ----------------------------------------------------------------------------
include 'components/chkconfig/config';
'/software/components/chkconfig/service/ntpd/on' = '';
#'/software/components/chkconfig/service/yum/off' = '';

# logrotate
# ----------------------------------------------------------------------------
include 'components/altlogrotate/config';

'/software/components/altlogrotate/entries/global' =
	dict('global', true,
		  'frequency', 'weekly',
		  'rotate', 4,
		  'create', true,
		  'compress', true,
		  'include', '/etc/logrotate.d');

'/software/components/altlogrotate/entries/wtmp' =
	dict('global', true,
		  'pattern', '/var/log/wtmp',
		  'frequency', 'monthly',
		  'rotate', 1,
		  'create', true,
		  'createparams', dict('mode', '0664',
								'owner', 'root',
								'group', 'utmp'));

# FreeIPA
# ----------------------------------------------------------------------------

## BEGIN : adapt ccm.conf if SSL is used

'/software/components/ccm' = {
	t = SELF;
	if ( FREEIPA_AII_USE_NSS ) { 
		t['cert_file'] = '/etc/ipa/quattor/certs/hostcert.pem';
		t['key_file'] = '/etc/ipa/quattor/certs/hostkey.pem';
		t['ca_file'] = '/etc/ipa/quattor/certs/ca.pem';
	};
	t;
};
## END : adapt ccm.conf ...

## BEGIN : freeipa part (goal is to create specifics hooks in aii...)

include {
	if (USE_FREEIPA) {
		return('quattor/aii/freeipa/default');
	} else {
		return(null);
	};
};
## END : freeipa part

# include ipa-client if USE_FREEIPA
include {
	if (USE_FREEIPA) {
		return('config/ipa_enrollment');
	} else {
		return(null);
	};
};

# AUTOFS
# ----------------------------------------------------------------------------

## when using autofs to mount the home directories of the users,
## make sure that ncm-autofs predepends ncm-accounts
variable AUTOFS_NEEDED = {
	if (exists(NFS_AUTOFS) && is_defined(NFS_AUTOFS) && NFS_AUTOFS && exists('/software/components/autofs/maps/grid/enabled') && value('/software/components/autofs/maps/grid/enabled')) {
		return(true);
	} else {
		return(false);
	};
};


'/software/components/chkconfig/service/' = {
	if (exists(SELF) && is_dict(SELF)) {
		tbl = SELF;
	} else {
		tbl = dict();
	};
	if( AUTOFS_NEEDED ) {
		tbl['autofs'] = dict('on','','startstop',true);
	};
	return(tbl);
};


####################################################################
####### NETWORK                                              #######
####################################################################

# Machines will always have a private NIC, and they always be
# installed through this private NIC. But then, we have to specify
# which NIC is the private one.
# In hardware machine template, the private NIC should have its "boot"
# attribute set to true.
variable HAS_PUBLIC_IF = { is_defined(DB_IP[escape(HOSTNAME + '.' + DEFAULT_DOMAIN)]) };
variable PRIVATE_IF ?= {
	if_name = '';
	if ( HAS_PUBLIC_IF ) {
		if_name = 'eth1';
	} else {
		if_name = 'eth0';
	};
	#check that the if exists in /hardware
	if( ! exists('/hardware/cards/nic/'+if_name) ) {
		error('network interface '+if_name+' was not found in hardware description');
	} else {
		return(if_name);
	};
};

variable PUBLIC_IF ?= {
	if_name = '';
	if (HAS_PUBLIC_IF) {
		if_name = 'eth0';
	} else {
		return(undef);
	};
	#check that the if exists in /hardware
	if(! exists('/hardware/cards/nic/'+if_name)) {
		error('network interface '+if_name+' was not found in hardware description');
	} else {
		return(if_name);
	};
};

variable GATEWAY ?= {
	if (HAS_PUBLIC_IF) {
		return(PUBLIC_GATEWAY);
	} else {
		return(PRIVATE_GATEWAY);
	};
};


# decide if we have to define static routes
# useful for workernodes, to avoid going through the gw
# to contact machines that have a private interface
variable SET_DIRECT_ROUTES = {
	if ( match(HOSTNAME,'^node') ) {
		return(true);
	} else {
		return(false);
	};
};


## network component setup
include 'components/network/config';

# Configuration of the network interfaces
include 'quattor/functions/network';
'/system/network/hostname' = HOSTNAME;
#'/system/network/domainname' = if ( HAS_PUBLIC_IF ) { DEFAULT_DOMAIN } else { DOMAIN };
'/system/network/domainname' = DOMAIN;
'/system/network/nameserver' = NAMESERVERS;
'/system/network/default_gateway' = GATEWAY;
'/system/network/interfaces' = copy_network_params_iihe(NETWORK_PARAMS_BOOT,NETWORK_PARAMS_DEFAULT);

# Configurarion of the static private routes
'/system/network/interfaces/' = if ( SET_DIRECT_ROUTES ) {
	if ( exists(SELF) && is_dict(SELF) ) {
		tbl = SELF;
	} else {
		tbl = dict();
	};
	  
	if ( exists(tbl[PRIVATE_IF]['route']) && is_list(tbl[PRIVATE_IF]['route']) ) {
		merge(tbl[PRIV_ROUTE_IF]['route'],gen_priv_routes_tbl());
	} else {
		tbl[PRIVATE_IF]['route'] = gen_priv_routes_tbl();
	};
	return(tbl);
} else {
	SELF;
};


# If there is a public interface, than we should also configure it.
'/system/network/interfaces/' = if (HAS_PUBLIC_IF) {
	tbl = SELF;
	tbl[PUBLIC_IF]['ip'] = DB_IP[escape(HOSTNAME+'.'+DEFAULT_DOMAIN)];
	tbl[PUBLIC_IF]['broadcast'] = PUBLIC_BROADCAST;
	tbl[PUBLIC_IF]['netmask'] = PUBLIC_NETMASK;
	tbl[PUBLIC_IF]['driver'] = value('/hardware/cards/nic/'+PUBLIC_IF+'/driver');
	tbl;
} else {
	SELF;
};


## enable network driver config through ncm-modprobe
include 'components/modprobe/config';
'/software/components/modprobe/modules' = {
	if (exists(SELF) && is_dict(SELF)) {
		tbl = SELF;
	} else {
		tbl = list();
	};
	netlist = value('/hardware/cards/nic');
	if (is_dict(netlist)) {
		ok = first(netlist,k,v);
		while (ok) {
			tbl[length(tbl)] =
				if(! exists('/hardware/cards/nic/'+k+'/driver')) {
					error('interface '+k+' has no driver part.');
				} else {
					dict(
						'name',value('/hardware/cards/nic/'+k+'/driver'),
						'alias',k,
					);
				};
			ok = next(netlist,k,v);
		};
	} else {
		error('Network interfaces problem while configuring ncm-modprobe');
	};
	return(tbl);
};