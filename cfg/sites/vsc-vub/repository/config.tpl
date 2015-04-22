######################################################################
#
# Standard repositories to use 
#
# RESPONSIBLE: Charles Loomis
#
#######################################################################
 
template repository/config;


include 'pan/functions';

# NOTE: This template should be the LAST thing included in a 
# machine profile.  If you include packages after this template
# then they will not be "resolved" and SPMA will not function
# correctly. 

# Repositories related to base OS and quattor client (should be first)
include 'repository/config/os';



#
# Standard stuff: resolve repository and purge not used entries
#
include { 'quattor/repository_cleanup' };


