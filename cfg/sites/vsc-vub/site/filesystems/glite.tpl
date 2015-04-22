# Define default filesystem layout for gLite nodes

template site/filesystems/glite;

include 'quattor/functions/filesystem';

include 'quattor/functions/filesystem';

variable DISK_SUP_DEV = {
  if (exists('/hardware/harddisks/sdb')) {
    return('sdb');
  } else if (exists('/hardware/harddisks/hdb')) {
    return("hdb");
  } else if (exists('/hardware/harddisks/xvdb')) {
    return('xvdb');
  } else {
    undef;
  };
};

#variable DISK_SUP_PARTS ?= list('lvm');
variable DISK_SUP_PARTS ?= list('');

# Scratch volume is a generic volume whose mount point can be changed according to site needs
variable DISK_GLITE_SCRATCH_SIZE ?= 0;
variable DISK_GLITE_SCRATCH_LOGVOL = 'zzscratch';
variable DISK_GLITE_SCRATCH_MOUNTPOINT = '/scratch';;

#variable DISK_GLITE_SCRATCH_SIZE ?= if ( is_defined(DISK_SUP_DEV) ) {
#                               -1;
#                             } else {
#                               0;
#                             };
variable DISK_GLITE_HOME_SIZE ?= 0*GB;
variable DISK_GLITE_OPT_SIZE ?= 2*GB;
variable DISK_GLITE_ROOT_SIZE ?= 1*GB;
variable DISK_GLITE_SWAREAS_SIZE ?= 0*GB;
variable DISK_GLITE_TMP_SIZE ?= 1*GB;
variable DISK_GLITE_USR_SIZE ?= 7*GB;
variable DISK_GLITE_VAR_SIZE = if ( DISK_GLITE_SCRATCH_SIZE == 0 ) {
                                 -1;
                               } else {
                                 10*GB;
                               };

# Don't use DISK_SWAP_SIZE as it is already defined...
variable NODE_SWAP_SIZE ?= 4*GB;

## scratch at the end, before var: these are the only ones with -1 (free space issues ;)
## use zscratch/zvar to make sure they are at the end
variable DISK_VOLUME_PARAMS = filesystem_layout_mod(dict(
  'home',          dict('size', DISK_GLITE_HOME_SIZE),
  'opt',           dict('size', DISK_GLITE_OPT_SIZE),
  'root',          dict('size', DISK_GLITE_ROOT_SIZE),
  'swap',          dict('size', NODE_SWAP_SIZE),
  'swareas',        dict('size', DISK_GLITE_SWAREAS_SIZE),
  'tmp',           dict('size', DISK_GLITE_TMP_SIZE),
  'usr',           dict('size', DISK_GLITE_USR_SIZE),
  'zvar',           dict('size', DISK_GLITE_VAR_SIZE),
  'zzscratch',       dict('size', DISK_GLITE_SCRATCH_SIZE,
                         'type', 'lvm',
                         'mountpoint', DISK_GLITE_SCRATCH_MOUNTPOINT,
                         'volgroup', 'vg.01',
                         'device', DISK_GLITE_SCRATCH_LOGVOL),
));