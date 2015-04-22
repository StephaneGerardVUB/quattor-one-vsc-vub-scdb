template site/cluster_info;

#
# basic site information
#
variable INFO_CLUSTER_NAME = 'IIHE PRODUCTION GRID';
variable INFO_SITERELEASE = 'SL 3';

'/system/cluster/name' = INFO_CLUSTER_NAME;
'/system/cluster/type' = 'batch';
'/system/state' = 'production';
'/system/siterelease' = INFO_SITERELEASE;
'/system/rootmail' = ADMIN_MAIL;
