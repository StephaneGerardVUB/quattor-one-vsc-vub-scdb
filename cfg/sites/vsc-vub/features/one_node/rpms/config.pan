template features/one_node/rpms/config;

# add opennebula repository
# add ceph-extra repository, to get support of ceph in kvm
include 'quattor/functions/repository';
'/software/repositories' = {
	add_repositories( list( 'opennebula_4.12_centos6_x86_64' ), 'repository/snapshot' );
};

# if you want to use a ceph datastore with kvm, you need a special build of kvm...
variable CEPH_DATASTORE ?= true;
'/software/repositories' = if ( CEPH_DATASTORE ) {
	add_repositories( list( 'ceph_extras_centos6_x86_64' ), 'repository/snapshot' );
};
# TODO : here we should add some code to make the ceph-extras repo prioritory over the others
# so that we get the kvm packages from the ceph_extras repo
# As a temp.solution, we've simply added "'priority' = 50;" in the repo template...

# install package opennebula-node-kvm
'/software/packages/{opennebula-node-kvm}' ?= dict();