############################################################
#
# template pro_site_system_filesystems
#
# RESPONSIBLE: Charles Loomis <charles.loomis@cern.ch>
#
############################################################

template config/filesystems;

## is by default 0
variable DISK_GLITE_SCRATCH_SIZE = {
  if (match(FULL_HOSTNAME,WORKER_NODE_REGEXP)||match(FULL_HOSTNAME,'^m[0-9]+')||match(FULL_HOSTNAME,'^frontier')) {
  	return(-1);
  } else {
  	return(null);
  };
};

## fs layout
variable FILESYSTEM_LAYOUT_CONFIG_SITE = {
    if (match(FULL_HOSTNAME,'^fs.wn.iihe.ac.be')) {
        return('site/filesystems/newfs');
    } else if (match(FULL_HOSTNAME,'^node')) {
        return('site/filesystems/classic_wn');
    } else if (match(FULL_HOSTNAME,'^m[0-9]+')) {
        return('site/filesystems/classic_wn');
    } else if (match(FULL_HOSTNAME,'test.iihe.ac.be')) {
        return('site/filesystems/classic_single_root');
    }  else {
        return('site/filesystems/classic_server');
    };

};


include 'site/filesystems/layout';

