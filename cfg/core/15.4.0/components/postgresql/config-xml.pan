# #
# Software subject to following license(s):
#   Apache 2 License (http://www.opensource.org/licenses/apache2.0)
#   Copyright (c) Responsible Organization
#

# #
# Current developer(s):
#   wouter.depypere@ugent.be <wouter.depypere@ugent.be>
#

# 
# #
# postgresql, 15.4.0, 1, 2015-06-03T15:21:52Z
#

unique template components/postgresql/config-xml;

include { 'components/postgresql/config-common' };

# Set prefix to root of component configuration.
prefix '/software/components/postgresql';

# Embed the Quattor configuration module into XML profile.
'code' = file_contents('components/postgresql/postgresql.pm'); 