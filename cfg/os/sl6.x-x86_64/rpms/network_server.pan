unique template rpms/network_server;

include { 'rpms/group/core' };

prefix '/software/packages';

# DHCP
'{dhcp}' = nlist();

# DHCP
'{tftp-server}' = nlist();

# Add Subversion
'{subversion}' = nlist();

