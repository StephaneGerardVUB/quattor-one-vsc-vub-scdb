structure template hardware/machine/one/base_small_vm;

'location' = undef;
'serialnumber' = undef;

'model' = 'ONE Virtual Machine';
#'bios/version' = '0.5.1';
#'bios/releasedate' = '01/01/2007';

#'cpu' = list(create('hardware/cpu/intel_xeon_E5_2650Lv2'));
'cpu' = list(create('hardware/cpu/kvm_vcpu'));

'harddisks' = dict('vda', create('hardware/harddisk/sas', 'capacity', 10*GB));

'ram' = list(create('hardware/ram/generic', 'size', 2*GB));

'cards/nic' = dict('eth0', create('hardware/nic/igb'),);

'cards/nic/eth0/boot' = true;
