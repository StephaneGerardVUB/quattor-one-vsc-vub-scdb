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


unique template components/opennebula/config-rpm;
include {'components/opennebula/schema'};

# Package to install
#"/software/packages" = pkg_repl("ncm-opennebula", "14.10.0-${rpm.release}", "noarch");
"/software/packages" = pkg_repl("ncm-opennebula", "14.10.0-rc2_SNAPSHOT20150429142452", "noarch");


#'/software/components/opennebula/dependencies/pre' ?= list('spma', 'accounts', 'sudo', 'useraccess');
'/software/components/opennebula/dependencies/pre' ?= list('spma', 'accounts', 'sudo');

'/software/components/opennebula/version' ?= '14.10.0';

