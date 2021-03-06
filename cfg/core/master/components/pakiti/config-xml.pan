# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Christos Triantafyllidis <ctria@grid.auth.gr>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
      # pakiti, 14.4.0-rc3-SNAPSHOT, rc3_SNAPSHOT20140507141710, 20140507-1516
      #

unique template components/pakiti/config-xml;

include { 'components/pakiti/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/pakiti';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/pakiti/pakiti.pm'); 
