unique template site/config-vm;


# AII opennebula VM conf

# Set network
prefix '/system/opennebula';
'vnet' = dict(
	'eth0', 'Private_T2B',
);

# Set storage
'datastore' = dict(
	'vda', 'default',
);

# set aii opennebula hooks
final variable OPENNEBULA_AII_FORCE = true; 
final variable OPENNEBULA_AII_ONHOLD = false;