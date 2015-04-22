unique template site/filesystems/classic_wn;


variable DISK_BOOT_PARTS = list(
  'root',
  'swap',
  'var',
  'scratch'
);
variable DISK_DEVICE_LIST = DISK_BOOT_PARTS;


variable DISK_VOLUME_PARAMS = {
      t = dict();
      t['root'] = dict('size', 10*GB,
                       'mountpoint', '/',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('root',DISK_BOOT_PARTS)+1));
      t['swap'] = dict('size', 2*GB,
                       'mountpoint', 'swap',
                       'fstype', 'swap',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('swap',DISK_BOOT_PARTS)+1));
      t['var'] = dict('size', 5*GB,
                       'mountpoint', '/var',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('var',DISK_BOOT_PARTS)+1));
      t['scratch'] = dict('size', -1,
                       'mountpoint', '/scratch',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('scratch',DISK_BOOT_PARTS)+1));
      t;
};
