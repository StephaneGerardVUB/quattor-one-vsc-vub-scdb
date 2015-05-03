object template profile_vm1.wn.iihe.ac.be;

include 'machine-types/non-grid/base';

# AII opennebula VM
include 'config/one/onevm';

#
# software repositories (should be last)
#
include PKG_REPOSITORY_CONFIG;

