# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   Alvaro Simon Garcia <Alvaro.SimonGarcia@UGent.be>
#

# 
# #
# opennebula, 14.10.0-rc2-SNAPSHOT, ${rpm.release}, 2015-04-04T23:24:15Z
#

unique template components/opennebula/config-xml;

include { 'components/opennebula/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/opennebula';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/opennebula/opennebula.pm'); 
