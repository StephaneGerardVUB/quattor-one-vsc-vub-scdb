unique template site/filesystems/classic_all_in_one;


variable DISK_BOOT_PARTS = list(
  'boot',
  'swap',
  'root',
);
variable DISK_DEVICE_LIST = DISK_BOOT_PARTS;


variable DISK_VOLUME_PARAMS = {
      t=dict();
      t['boot'] = dict('size', 64*MB,
                       'mountpoint', '/boot',
                       'fstype', 'ext2',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('boot',DISK_BOOT_PARTS)+1));
      t['swap'] = dict('size', 2*GB,
                       'mountpoint', 'swap',
                       'fstype', 'swap',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('swap',DISK_BOOT_PARTS)+1));
      t['root'] = dict('size', -1,
                       'mountpoint', '/',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('root',DISK_BOOT_PARTS)+1));
      t;
};
