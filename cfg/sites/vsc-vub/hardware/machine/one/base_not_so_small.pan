structure template hardware/machine/one/base_not_so_small;

'location' = undef;
'serialnumber' = undef;

'model' = 'ONE Virtual Machine';
#'bios/version' = '0.5.1';
#'bios/releasedate' = '01/01/2007';

'cpu' = list(create('hardware/cpu/intel_xeon_E5_2650Lv2'));

'harddisks' = dict('vda', create('hardware/harddisk/sas', 'capacity', 6*GB));

'ram' = list(create('hardware/ram/generic', 'size', 4*GB));

'cards/nic' = dict('eth0', create('hardware/nic/igb'),);

'cards/nic/eth0/boot' = true;
