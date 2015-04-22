unique template users/config;


## include them on
##  CE
##  UIs
##  dcache headnode(+pools?)
##  WNs
##  fileserver
variable INCLUDE_CMS_LOCAL_USERS_REGEXP = '^(mtoptest|dcache2-shadow|m[0-9]+|m[0-9]+g|gridce|ui-shadow|cream0[1-9]|cream0[1-9]g|maite|behar|behar[0-9]+|node[0-9]+-[0-9]+.wn|fs.wn|test)(.wn)?.iihe.ac.be';

include {
    if (match(FULL_HOSTNAME,INCLUDE_CMS_LOCAL_USERS_REGEXP)) {
    	USE_NCM_ACCOUNT = true;
        return('config/cms/local_users');
    } else {
        return(null)
    };
};


## CMS external users
## only need an account on storage

variable INCLUDE_CMS_EXTERNAL_USERS_REGEXP = '^(dcache2-shadow|maite|behar|behar[0-9]+)(.wn)?.iihe.ac.be';

include {
    if (match(FULL_HOSTNAME,INCLUDE_CMS_EXTERNAL_USERS_REGEXP)) {
    	USE_NCM_ACCOUNT = true;
        return('config/cms/external_users');
    } else {
        return(null)
    };
};

## extra users: only on UIs

variable INCLUDE_EXTRA_USERS_REGEXP = '^(m[0-9]+|m[0-9]+g).iihe.ac.be';

include {
    if (match(FULL_HOSTNAME,INCLUDE_EXTRA_USERS_REGEXP)) {
    	USE_NCM_ACCOUNT = true;
        return('config/extra_users');
    } else {
        return(null)
    };
};

## non-cms users: only on UIs

variable INCLUDE_NON_CMS_USERS_REGEXP = '^(m[0-9]+|m[0-9]+g|gridce|cream0[1-9]|node[0-9]+-[0-9]+.wn|fs.wn).iihe.ac.be';

include {
    if (match(FULL_HOSTNAME,INCLUDE_NON_CMS_USERS_REGEXP)) {
    	USE_NCM_ACCOUNT = true;
        return('config/non-cms/local_users');
    } else {
        return(null)
    };
};

## This block is problematic when accounts are not configured on the machine,
## because in this case, ncm-accounts RPM is not installed, while it is configured...
## These configurations depend on the value of AUTOFS_NEEDED
#'/software/components/accounts/dependencies/pre' = {
#	if (exists(SELF) && is_dict(SELF)) {
#		tbl = SELF;
#	} else {
#		return(SELF);
#	};
#	if( AUTOFS_NEEDED ) {
#		tbl[length(tbl)]="autofs";
#	};
#	return(tbl);
#};