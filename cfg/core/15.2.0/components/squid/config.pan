# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Marco Emilio Poleggi <Marco.Poleggi@cern.ch>
#

# #
# Author(s): Jane SMITH, Joe DOE
#

# #
      # squid, 14.4.0-rc3-SNAPSHOT, rc3_SNAPSHOT20140507141716, 20140507-1516
      #

unique template components/squid/config;

include { 'components/squid/config-common' };
include { 'components/squid/config-rpm' };
