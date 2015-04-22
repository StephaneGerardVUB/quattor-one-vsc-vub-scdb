unique template site/filesystems/classic_single_root;


variable DISK_BOOT_PARTS = list(
  'root',
);
variable DISK_DEVICE_LIST = DISK_BOOT_PARTS;

variable DISK_VOLUME_PARAMS = {
      t = dict();
      t['root'] = dict('size', -1,
                       'mountpoint', '/',
                       'type', 'partition',
                       'device', DISK_BOOT_DEV+to_string(index('root',DISK_BOOT_PARTS)+1));
      t;
};
