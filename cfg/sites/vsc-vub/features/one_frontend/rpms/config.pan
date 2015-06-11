template features/one_frontend/rpms/config;

# add opennebula and rubygems repositories
include 'quattor/functions/repository';
'/software/repositories' = {
	add_repositories( list( 'opennebula_4.12_centos6_x86_64', 'sl6_iihe_rubygems' ), 'repository/snapshot' );
};


# install packages : opennebula-sunstone and opennebula-server
'/software/packages/{opennebula-sunstone}' ?= dict();
'/software/packages/{opennebula-server}' ?= dict();

# Uncomment the line below if you are not able to install the ruby gems
# under the form of rpm packages (generated with Alvaro's script).
#include { 'config/one/build_rubygems' };

# /usr/share/one/install_gems
# will install gems under the form of packages generated with this tool :
# https://github.com/OpenNebula/addon-installgems
# (see the sl6_iihe_rubygems added above)
include 'features/one_frontend/rpms/rubygems';


# needed for sunstone to start, though it is not a dependency
'/software/packages/{libxslt}' ?= dict();