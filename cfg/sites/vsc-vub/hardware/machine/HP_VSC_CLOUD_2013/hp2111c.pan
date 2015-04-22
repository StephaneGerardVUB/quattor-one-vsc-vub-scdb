#ProLiant SL210t Gen8
structure template hardware/machine/HP_VSC_CLOUD_2013/hp2111c;

'location' = 'rack12_u39_left';

'serialnumber' = '2111c';

'cpu' = list(create('hardware/cpu/intel_xeon_E5_2650Lv2'),
             create('hardware/cpu/intel_xeon_E5_2650Lv2'));

'harddisks' = nlist('sda', create('hardware/harddisk/sas_300'));

'ram' = list(create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'),
             create('hardware/ram/ram_8192'));

'cards/nic' = nlist('eth0',create('hardware/nic/igb'),
                    'eth1',create('hardware/nic/igb'));

'cards/nic/eth0/hwaddr' = '38:ea:a7:a3:18:56';

'cards/nic/eth1/hwaddr' = '38:ea:a7:a3:18:57';

'cards/nic/eth0/boot' = true;