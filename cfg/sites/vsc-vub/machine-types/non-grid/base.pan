############################################################
#
# template machine-types/non-grid/base
#
# This template is to install a server without middleware.
#
# RESPONSIBLE: Stéphane GÉRARD
#
############################################################

unique template machine-types/non-grid/base;


# Include static information and derived global variables.
variable SITE_DB_TEMPLATE ?= 'site/databases';
include { SITE_DB_TEMPLATE };
variable SITE_GLOBAL_VARIABLES ?= 'site/global_variables';
include { SITE_GLOBAL_VARIABLES };

# When true, only the initial part of NFS configuration is done during base OS configuration.
variable OS_POSTPONE_NFS_CONFIG ?= false;


# Define site functions
variable SITE_FUNCTIONS_TEMPLATE ?= 'site/functions';
include { SITE_FUNCTIONS_TEMPLATE };


# Profile_base for profile structure
include { 'quattor/profile_base' };


# NCM core components
include { 'components/spma/config' };
#include { 'components/grub/config' };


# Hardware
include { 'hardware/functions' };
'/hardware' = if ( exists( DB_MACHINE[escape(FULL_HOSTNAME)] ) )
{
	create( DB_MACHINE[escape(FULL_HOSTNAME)] );
} else {
	error( FULL_HOSTNAME + ' : hardware not found in machine database' );
};
variable MACHINE_PARAMS_CONFIG ?= undef;
include { MACHINE_PARAMS_CONFIG };
'/hardware' = if ( exists( MACHINE_PARAMS ) && is_nlist( MACHINE_PARAMS ) )
{
	update_hw_params();
} else {
	SELF;
};


# Cluster specific configuration
variable CLUSTER_INFO_TEMPLATE ?= 'site/cluster_info';
include { CLUSTER_INFO_TEMPLATE };


# Common site machine configuration
variable SITE_CONFIG_TEMPLATE ?= 'site/config';
include { SITE_CONFIG_TEMPLATE };


# File system configuration.
# pro_site_system_filesystems is legacy name and is used if present.
# filesystem/config is new generic approach for configuring file systems : use if it is present. It requires
# a site configuration template passed in FILESYSTEM_LAYOUT_CONFIG_SITE (same name as previous template
# but not the same contents).
variable FILESYSTEM_CONFIG_SITE ?= if_exists( 'filesystem/config' );
variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= 'site/filesystems/glite';
variable FILESYSTEM_CONFIG_SITE ?= 'site/filesystems/glite';


# Select OS version based on machine name
include { 'os/version' };

# Define OS related namespaces
variable OS_NS_CONFIG = 'config/';
variable OS_NS_OS = OS_NS_CONFIG + 'core/';
variable OS_NS_QUATTOR = OS_NS_CONFIG + 'quattor/';
variable OS_NS_RPMLIST = 'rpms/';
variable OS_NS_REPOSITORY = 'repository/';


# Some useful pan functions
include { 'pan/functions' };


# Configure Bind resolver
variable SITE_NAMED_CONFIG_TEMPLATE ?= 'site/named';
include { SITE_NAMED_CONFIG_TEMPLATE };


# Kernel version and CPU architecture
include { 'os/kernel_version_arch' };


# Include OS version dependent RPMs
include { if_exists( OS_NS_OS + 'base' ) };


# Quattor client software
include { 'quattor/client/config' };


# Check if NFS server and/or client should be configured on the current system.
# This template defines variables NFS_xxx_ENABLED used by other templates. 
# Also include NFS-related packages
#include { 'features/nfs/init' };
#include { if ( NFS_CLIENT_ENABLED ) 'rpms/nfs-client' };


# Configure filesystem layout.
# Must be done after NFS initialisation as it may tweak some mount points.
include { return(FILESYSTEM_CONFIG_SITE) };


# Configure NFS if necessary
#include { if ( NFS_SERVER_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/server/config' };
#include { if ( NFS_CLIENT_ENABLED && !OS_POSTPONE_NFS_CONFIG ) 'features/nfs/client/config' };


# Site Monitoring
variable MONITORING_CONFIG_SITE ?= 'site/monitoring/config';
include { if_exists( MONITORING_CONFIG_SITE ) };


# AII component must be included after much of the other setup.
include { OS_NS_QUATTOR + 'aii' };


# Add local users if some configured
variable USER_CONFIG_INCLUDE = if ( exists( USER_CONFIG_SITE ) && is_defined( USER_CONFIG_SITE ) )
{
	return( 'users/config' );
} else {
	return( null );
};
include { USER_CONFIG_INCLUDE };


# Default repository configuration template 
variable PKG_REPOSITORY_CONFIG ?= 'repository/config';


# Pakiti
variable PAKITI_ENABLED ?= false;
include {
	if ( PAKITI_ENABLED ) {
		'features/pakiti/config';
	} else {
		null;
	};
};
