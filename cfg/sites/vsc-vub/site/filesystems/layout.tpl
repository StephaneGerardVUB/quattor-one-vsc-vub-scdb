unique template site/filesystems/layout;

include 'quattor/functions/filesystem';

variable FILESYSTEM_LAYOUT_CONFIG_SITE ?= null;

# Function to update DISK_VOLUME_PARAMS.
# This function allows to merge site-specific volume parameters with default ones.
# Calling sequence is  :
#    variable DISK_VOLUME_PARAMS = filesystem_layout_mod(volume_dict);
# where 'volume_dict' has the same format as DISK_VOLUME_PARAMS.
function filesystem_layout_mod = {
  function_name = 'filesystem_layout_mod';
  if ( (ARGC != 1) || !is_dict(ARGV[0]) ) {
    error(function_name+': one argument required, must be a dict');
  };

  foreach (volume;params;ARGV[0]) {
    if ( exists(SELF[volume]) ) {
      foreach (key;value;params) {
        SELF[volume][key] = value;
      };
    } else {
      SELF[volume] = params;
    };
  };
  SELF;
};

variable DISK_BOOT_DEV ?= boot_disk();
variable DISK_BOOT_DEV ?= {
  if (exists('/hardware/harddisks/sda')) {
    return('sda');
  } else if (exists('/hardware/harddisks/sdb')) {
    return('sdb');
  } else if (exists('/hardware/harddisks/sdd')) {
    return('sdd');
  } else if (exists('/hardware/harddisks/sdg')) {
    return('sdg');
  } else if (exists('/hardware/harddisks/hda')) {
    return('hda');
  } else if (exists('/hardware/harddisks/xvda')) {
    return('xvda');
  } else if (exists('/hardware/harddisks/vda')) {
    return('vda');
  } else if (exists('/hardware/harddisks/cciss1')) {
  	return(escape('cciss/c1d0p'));
  } else if (exists('/hardware/harddisks/cciss')) {
  	return(escape('cciss/c0d0p'));
  } else if (exists('/hardware/harddisks/{cciss/c1d0}')) {
  	return(escape('cciss/c1d0p'));
  } else {
    error('Unable to locate primary disk Olivier');
  };
};

# Handle disk device names as /dev/cciss/xxxpn, where 'p' must be inserted
# between device name and partition number (e.g. HP SmartArray)
variable DISK_BOOT_PART_PREFIX ?= if ( exists('/hardware/harddisk/'+DISK_BOOT_DEV+'/part_prefix') ) {
                                    value('/hardware/harddisk/'+DISK_BOOT_DEV+'/part_prefix');
                                  } else {
                                    '';
                                  };

# An ordered list of partition. Index will be used to build device name (index+1).
# Value is an arbitrary string.
variable DISK_BOOT_PARTS ?= list(
  'boot',
  'root',
  'swap',
  'lvm',
);

variable DISK_SWAP_SIZE ?= 4*GB;


# Define list of volume (partition, logical volumes, md...).
# Default list is a disk with 4 partitions : /boot, /, swap and one partition for LVM.
# By default, LVM configuration is one logical volume for /usr, /opt, /var, /tmp with all
# the unused space in /var.
# Default layout can be adjusted to site-specific needs by tweaking this variable in template
# designated by FILESYSTEM_LAYOUT_CONFIG_SITE.
# Key is an arbitrary name referenced by DISK_DEVICE_LIST.
variable DISK_VOLUME_PARAMS ?= {
  SELF['boot'] = dict('size', 256*MB,
                       'mountpoint', '/boot',
                       'fstype', 'ext2',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('boot',DISK_BOOT_PARTS)+1));
  SELF['home'] = dict('size', 0*GB,
                       'mountpoint', '/home',
                       'type', 'lvm',
                       'volgroup', 'vg.01',
                       'device', 'homevol');
  SELF['opt'] = dict('size', 2*GB,
                      'mountpoint', '/opt',
                      'type', 'lvm',
                      'volgroup', 'vg.01',
                      'device', 'optvol');
  SELF['root'] = dict('size', 1*GB,
                       'mountpoint', '/',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('root',DISK_BOOT_PARTS)+1));
  SELF['swap'] = dict('size', DISK_SWAP_SIZE,
                       'mountpoint', 'swap',
                       'fstype', 'swap',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('swap',DISK_BOOT_PARTS)+1));
  SELF['swareas'] = dict('size', 0*GB,
                          'mountpoint', '/swareas',
                          'type', 'lvm',
                          'volgroup', 'vg.01',
                          'device', 'swareasvol');
  SELF['tmp'] = dict('size', 1*GB,
                      'mountpoint', '/tmp',
                      'type', 'lvm',
                      'volgroup', 'vg.01',
                      'device', 'tmpvol');
  SELF['usr'] = dict('size', 5*GB,
                      'mountpoint', '/usr',
                      'type', 'lvm',
                      'volgroup', 'vg.01',
                      'device', 'usrvol');
  SELF['zvar'] = dict('size', -1,
                      'mountpoint', '/var',
                      'type', 'lvm',
                      'volgroup', 'vg.01',
                      'device', 'zvarvol');
  SELF['vg.01'] = dict('size', -1,
                        'type', 'vg',
                        'devices', list(DISK_BOOT_DEV+to_string(index('lvm',DISK_BOOT_PARTS)+1)));
  SELF;
};

# List order of creation, for volume/partition where it matters
variable DISK_DEVICE_LIST ?= list('boot',
                                  'root',
                                  'swap',
                                 );

# Include site-specific customization to volume list or creation order
include { FILESYSTEM_LAYOUT_CONFIG_SITE };


variable SOFT_RAID_LEVEL ?= -1;
variable SOFT_RAID_DISKS ?= list("sda","sdb");
variable SOFT_DISK_BOOT_PARTS ?= dict('boot','boot',
                                       'root','root',
                                       'swap','swap',
                                       'vg.01','lvm');

variable DISK_VOLUME_PARAMS = {
    ## todo
    ##   change type to md
    ##   remove device
    ##   add devices
    ##   set raidlevel
    if (SOFT_RAID_LEVEL == -1) {
        map = dict();
    } else {
        map = SOFT_DISK_BOOT_PARTS;
    };
    foreach(k;v;map) {

        mn = 'md'+to_string(index(v,DISK_BOOT_PARTS));
        SELF[mn] = dict('type','md',
                         'devices',list(),
                         'raid_level',SOFT_RAID_LEVEL
                         );

        SELF[k]['devices'] = list();
        foreach (i;d;SOFT_RAID_DISKS) {
            pn = d+to_string(index(v,DISK_BOOT_PARTS)+1);
            SELF[mn]['devices'][i] = pn;
            #SELF[k]['devices'][i] = pn;
            SELF['_'+pn] = dict('size',SELF[k]['size'],
                                 'device',pn,
                                 'type','partition',
                                );
        };


        if (SELF[k]['type'] == 'partition') {
            SELF[k]['type'] = 'raid';
            SELF[k]['device'] = mn;
        } else if (SELF[k]['type'] == 'vg') {
            SELF[k]['devices'] = list(mn);
        } else {
            error('AddMD: Unsupported type '+SELF[k]['type']);
        };

    };

    SELF;
};



# Remove entries with a zero size.
variable DISK_VOLUME_PARAMS = {
  volumes = dict();
  foreach (volume;params;SELF) {
    if ( !exists(params['size']) || (params['size'] != 0) ) {
      volumes[volume] = SELF[volume];
    };
  };
  volumes;
};

# Update DISK_DEVICE_LIST to include all volumes in DISK_VOLUME_PARAMS, preserving original order
variable DISK_DEVICE_LIST = {
  foreach (volume;params;DISK_VOLUME_PARAMS) {
    if ( index(volume,SELF) < 0 ) {
      SELF[length(SELF)] = volume;
    };
  };
  SELF;
};


# Build a list of partitions by physical device
variable DISK_PART_BY_DEV = dict();   # Workaround PAN bug
variable DISK_PART_BY_DEV = {
  foreach (i;dev_name;DISK_DEVICE_LIST) {
    if ( match(DISK_VOLUME_PARAMS[dev_name]['type'], 'md|vg') ) {
      if ( exists(DISK_VOLUME_PARAMS[dev_name]['devices']) ) {
        devices = DISK_VOLUME_PARAMS[dev_name]['devices'];
      } else {
        error('Missing physical device list for device '+dev_name);
      };
    } else {
      devices = list(dev_name);
    };

    foreach (j;device;devices) {
      # If the device is not present in DISK_VOLUME_PARAMS,
      # assume a partition using the unused part of the disk
      if ( exists(DISK_VOLUME_PARAMS[device]) ) {
        params = DISK_VOLUME_PARAMS[device];
      } else if ( exists(DISK_VOLUME_PARAMS['_'+device]) ) {
        params = DISK_VOLUME_PARAMS['_'+device];
      } else {
        params = dict('device', device,
                       'type', 'partition',
                       'size', -1);
      };
      if ( params['type'] == 'partition' ) {
        if ( !exists(params['device'])  ) {
          error("No physical device for partition '"+params['device']+"'");
        };
        toks = matches(params['device'], '^(.*)\d+$');
        if ( length(toks) != 2 ) {
          error('Invalid device name pattern ('+params['device']+')');
        } else {
          phys_dev = toks[1];
        };
        if ( !exists(SELF[phys_dev]) ) {
          SELF[phys_dev] = dict();
        };
        SELF[phys_dev][params['device']] = params['size'];
      };
    };
  };

  SELF;
};


'/system/blockdevices/physical_devs' = {
  foreach (phys_dev;part_list;DISK_PART_BY_DEV) {
    SELF[phys_dev] = dict ('label', 'msdos');
  };
  SELF;
};

'/system/blockdevices/partitions' ?= dict();  # Workaround PAN bug
'/system/blockdevices/partitions' = {
  foreach (phys_dev;part_list;DISK_PART_BY_DEV) {
    partitions_add (phys_dev, part_list);
  };
  SELF;
};

# Add MD and VG definitions
'/system/blockdevices' = {
  foreach (i;dev_name;DISK_DEVICE_LIST) {
    params = DISK_VOLUME_PARAMS[dev_name];
    if ( match(params['type'],'md|vg') ) {
      # First build partition list with the appropriate name.
      # Dereference until it is a real partition.
      partitions = list();
      foreach (j;device;params['devices']) {
        part_name = device;
        if (match(device,'^md')){
          partitions[length(partitions)] = 'md/' + part_name;
        } else {
           part_not_found = true;
           while ( part_not_found ) {
            if ( exists(DISK_VOLUME_PARAMS[part_name]) ) {
              part_name = DISK_VOLUME_PARAMS[part_name]['device'];
            } else {
              part_not_found = false;
            };
          };
          partitions[length(partitions)] = 'partitions/' + part_name;
        };
      };
      if ( params['type'] == 'md') {
        if ( !exists(SELF['md']) ) {
          SELF['md'] = dict();
        };
        if ( exists(params['raid_level']) ) {
          raid_level = 'RAID'+to_string(params['raid_level']);
        } else {
            error(dev_name);
          raid_level = 'RAID0';
        };
        SELF['md'][dev_name] = dict('device_list', partitions,
                                     'raid_level', raid_level);
      } else if ( params['type'] == 'vg' ) {
         if ( !exists(SELF['volume_groups']) ) {
          SELF['volume_groups'] = dict();
        };
        SELF['volume_groups'][dev_name] = dict('device_list', partitions);
      };
    };
  };

  SELF;
};

# Build a list of logical volumes per volume group
variable DISK_LV_BY_VG = dict();   # Workaround PAN bug
variable DISK_LV_BY_VG = {
  foreach (i;device;DISK_DEVICE_LIST) {
    params = DISK_VOLUME_PARAMS[device];
    if ( params['type'] == 'lvm' ) {
      # Already checked for existence
      params = DISK_VOLUME_PARAMS[device];

      if ( !exists(params['device'])  ) {
        error("Logical volume name undefined for '"+device+"'");
      };
      if ( exists(params['volgroup'])  ) {
        vg_name = params['volgroup'];
      } else {
        error("No volume group defined for logical volume '"+params['device']+"'");
      };
      if ( !exists(SELF[vg_name]) ) {
        SELF[vg_name] = dict();
      };
      SELF[vg_name][params['device']] = params['size'];
    };
  };

  SELF;
};


'/system/blockdevices/logical_volumes' ?= dict();  # Workaround PAN bug
'/system/blockdevices/logical_volumes' = {
  foreach (vg_name;lv_list;DISK_LV_BY_VG) {
    lvs_add (vg_name, lv_list);
  };
  SELF;
};


# Filesystems will be created in the exact order they are listed in DISK_DEVICE_LIST;
# Ignore entries in this list that have no mount point defined
'/system/filesystems' ?= list();  # Workaround PAN bug
'/system/filesystems' = {
  foreach (i;dev_name;DISK_DEVICE_LIST) {
    params = DISK_VOLUME_PARAMS[dev_name];
    if ( exists(params['mountpoint']) ) {
      if ( params['type'] == 'partition' ) {
        block_device = 'partitions/' + params['device'];
      } else if ( params['type'] == 'lvm' ) {
        block_device = 'logical_volumes/' + params['device'];
      } else if ( params['type'] == 'raid' ) {
        block_device = 'md/' + params['device'];
      };
      if ( exists(params['fstype']) ) {
        fs_type = params['fstype'];
      } else {
        fs_type = 'ext3';
      };
      if ( exists(params['format']) ) {
        format = params['format'];
      } else {
        format = true;
      };
      if ( exists(params['preserve']) ) {
        preserve = params['preserve'];
      } else {
        preserve = true;
      };
      if ( exists(params['mount']) ) {
        mount = params['mount'];
      } else {
        mount = true;
      };
      fs_params = dict ('block_device', block_device,
                         'mountpoint', params['mountpoint'],
                         'format', format,
                         "mount", mount,
                         'preserve', preserve,
                         'type', fs_type);
      filesystem_mod(fs_params);
    };
  };
  SELF;
};