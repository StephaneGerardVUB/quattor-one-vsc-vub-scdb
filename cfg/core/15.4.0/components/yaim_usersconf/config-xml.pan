# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Jan van Eldik <Jan.van.Eldik@cern.ch>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
# yaim_usersconf, 15.4.0, 1, 2015-06-03T15:27:32Z
#

unique template components/yaim_usersconf/config-xml;

include { 'components/yaim_usersconf/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/yaim_usersconf';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/yaim_usersconf/yaim_usersconf.pm'); 
