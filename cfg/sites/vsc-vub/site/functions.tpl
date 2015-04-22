declaration template site/functions;

# Function to ease creation of autofs map
# It takes 3 arguments :
#  - IIHE_AUTOFS_MAP : name of the autofs map
#  - IIHE_AUTOFS_OPTS : options of the mount
#  - IIHE_AUTOFS_ENTRIES : dict describing the mount (mount point on client side, nfs server,...)
# Usage :
#	'/software/components/autofs/maps' = gen_autofs_map(IIHE_AUTOFS_MAP, IIHE_AUTOFS_OPTS, IIHE_AUTOFS_ENTRIES);
#
function gen_autofs_map = {

	lst = SELF;
	lst[IIHE_AUTOFS_MAP] = dict(
		'enabled',		true,
		'mapname',		'/etc/auto.' + IIHE_AUTOFS_MAP,
		'mountpoint',	'/' + IIHE_AUTOFS_MAP + '_mnt',
		'options',		IIHE_AUTOFS_OPTS,
		'type',			'file',
		'entries',		IIHE_AUTOFS_ENTRIES
	);
	return(lst);

};

# Function to ease creation of autofs symlink
# It takes 1 argument :
#  - IIHE_AUTOFS_MAP : name of the autofs map
# Usage :
#	'/software/components/symlink/links' = gen_autofs_symlink(IIHE_AUTOFS_MAP);
#
function gen_autofs_symlink = {

		
	links = SELF;
	if ( !is_defined(links) || !is_list(links) ) {
		links = list();
	};

	entry = dict();
	entry['name'] = '/' + IIHE_AUTOFS_MAP;
	entry['target'] = '/' + IIHE_AUTOFS_MAP + '_mnt/' + IIHE_AUTOFS_MAP;
	entry['exists'] = false;
	entry['replace'] = dict('all','yes');
	links[length(links)] = entry;
	
	return(links);
	
};

#This function generates the table of private routes
function gen_priv_routes_tbl = {
	list = DIRECT_ROUTES_DEST;
	tbl = list(); 
	foreach(k;v;list) {
		if ( ( ! match(HOSTNAME,v) ) ) {
			tbl[length(tbl)] = dict(
				"address", DB_IP[escape(v+'.'+DEFAULT_DOMAIN)],
				"gateway", DB_IP[escape(v+'.'+PRIVATE_DOMAIN)],
			);
		};
	};  	
	return(tbl);
};

###################################################################
# This function configures all the network interfaces
# declared in /hardware/cards/nic. It takes one or two arguments :
# - 1st arg. : dict with net params for the boot-nic
# - 2nd arg. (optional) : dict with default params for other nics
# For every interface, it there is an entry in variable MTU, it is
# also applied to the interface.
###################################################################

variable MTU ?= dict();

function copy_network_params_iihe = {

	#check arguments
	if ( ARGC == 0 ) {
		error('At least one argument must be given.');
	} else {
		net_params_boot = ARGV[0];
		if ( ARGC == 2 ) {
			net_params_default = ARGV[1];
		};
	};
	
	if_list=value('/hardware/cards/nic');
	if ( is_dict(if_list) ) {
		foreach (if_name;v;if_list) {
			net_params = dict();
			if ( if_name == boot_nic() ) {
				net_params = net_params_boot;
				net_params['onboot'] = 'yes';
				net_params['bootproto'] = 'static';
			} else {
				if ( !is_defined(net_params_default) ) {
					net_params['onboot'] = 'no';
					net_params['bootproto'] = 'dhcp';
				} else {
					#net_params = net_params_default;
					net_params['onboot'] = 'yes';
					net_params['bootproto'] = 'static';
					net_params = net_params_default;
				};
			};
			
			net_params['driver'] = value('/hardware/cards/nic/'+to_string(if_name)+'/driver');
			mtu_size = undef;
			if_type = replace('\d+$','',if_name);
			# In the case of the boot interface, doesn't allow an explicit declaration of
			# the MTU value both for the boot interface name and for the BOOT entry. If
			# one of them is undefined, take the explicit one.
			if ( exists(MTU['BOOT']) && (if_name == boot_nic()) ) {
				if ( is_defined(MTU["BOOT"]) ) {
					if ( is_defined(MTU[if_name]) ) {
						error(format("MTU size defined for '%s' (%d): MTU['BOOT'] entry (%d) not allowed",if_name,MTU[if_name],MTU['BOOT']));
					} else {
						mtu_size = MTU['BOOT'];
					};
				} else if ( is_defined(MTU[if_name]) ) {
					mtu_size = MTU[if_name];
				};
			} else if ( exists(MTU[if_name])) {
				mtu_size = MTU[if_name];
			} else if ( exists(MTU[if_type])) {
				mtu_size = MTU[if_type];
			} else if ( exists(MTU['DEFAULT'])) {
				mtu_size = MTU['DEFAULT'];
			};
			if ( is_defined(mtu_size) ) {
				net_params['mtu'] = mtu_size;
			};

			net_params['set_hwaddr'] = true;
			SELF[if_name] = net_params;
		};

	} else if ( !is_defined(if_list) ) {
		error('No network interface defined in the configuration');

	} else {
		error('/hardware/cards/nic must be a dict');
	};

	SELF;
};