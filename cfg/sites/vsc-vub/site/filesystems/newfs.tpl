unique template site/filesystems/newfs;

## is a dom0
include 'site/filesystems/dom0';

## add /dev/sdb config
## add it manually. later we can try with aii2
'/system/blockdevices' = dict (
   'physical_devs', dict (
                        'sdb', dict ('label', 'gpt'),
                           ),
   'volume_groups', dict(
       'main', dict(
           'device_list', list('partitions/sdb1'),
       ),
   ),
   'partitions', dict (
       'sdb1', dict (
           'holding_dev', 'sdb',
       ),
   ),    
   'logical_volumes', dict(
       'pooluser', dict(
           'size', 250*GB,
           'volume_group', 'main'
       ),
       'swmgrs', dict(
           'size', 400*GB,
           'volume_group', 'main'
       ),
       'sandbox', dict(
           'size', 400*GB,
           'volume_group', 'main'
       ),
       'localgrid', dict(
           'size', 250*GB,
           'volume_group', 'main'
       ),
       'user', dict(
           'size', 5000*GB,
           'volume_group', 'main'
       ),
    )
);

'/system/filesystems' = list (
   dict ('mount', true, 'preserve', true, 'format', true, 'mountopts', 'auto', 'type', 'xfs',
          'mountpoint','/pooluser',
          'block_device', 'logical_volumes/pooluser',
   ),
   dict ('mount', true, 'preserve', true, 'format', true, 'mountopts', 'auto', 'type', 'xfs',
          'mountpoint','/swmgrs',
          'block_device', 'logical_volumes/swmgrs',
   ),
   dict ('mount', true, 'preserve', true, 'format', true, 'mountopts', 'auto', 'type', 'xfs',
          'mountpoint','/sandbox',
          'block_device', 'logical_volumes/sandbox',
   ),
   dict ('mount', true, 'preserve', true, 'format', true, 'mountopts', 'auto', 'type', 'xfs',
          'mountpoint','/localgrid',
          'block_device', 'logical_volumes/localgrid',
   ),
   dict ('mount', true, 'preserve', true, 'format', true, 'mountopts', 'auto', 'type', 'xfs',
          'mountpoint','/user',
          'block_device', 'logical_volumes/user',
   ),
);
