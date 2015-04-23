template site/databases;

# Defines the mapping between the full hostname and the IP
# address.
variable DB_IP = dict(

  ### SERVERS ###

  escape('ccq.iihe.ac.be'),'193.190.247.140',
  escape('ccqg.iihe.ac.be'),'193.190.247.126',
  escape('ccq.wn.iihe.ac.be'),'192.168.10.100',
  escape('ccq3g.iihe.ac.be'),'193.190.247.125',

  escape('qclig.iihe.ac.be'),'193.58.172.13',
  escape('qclig.wn.iihe.ac.be'),'192.168.10.115',

  escape('gangliat2b.iihe.ac.be'),'193.58.172.58',
  escape('gangliat2b.wn.iihe.ac.be'),'192.168.10.174',
  
  escape('proxyt2b.iihe.ac.be'),'193.58.172.59',
  escape('proxyt2b.wn.iihe.ac.be'),'192.168.10.32',
  
  escape('test.iihe.ac.be'),'193.58.172.122',
  escape('test.wn.iihe.ac.be'),'192.168.10.97',
  
  escape('vscvhost01.wn.iihe.ac.be'),'192.168.10.142',
  escape('vscvhost02.wn.iihe.ac.be'),'192.168.10.143',
  escape('vscvhost03.wn.iihe.ac.be'),'192.168.10.144',
  escape('vscvhost04.wn.iihe.ac.be'),'192.168.10.145',
  escape('vscvhost05.wn.iihe.ac.be'),'192.168.10.146',
  escape('vscvhost06.wn.iihe.ac.be'),'192.168.10.147',
  escape('vscvhost07.wn.iihe.ac.be'),'192.168.10.148',
  escape('vscvhost08.wn.iihe.ac.be'),'192.168.10.149',

  ### WORKERNODES ###
  
  escape('node19-101.wn.iihe.ac.be'),'192.168.19.101',
  escape('node19-102.wn.iihe.ac.be'),'192.168.19.102',

);

# Defines the mapping between the full hostname and the
# physical machine.
variable DB_MACHINE = dict(

  ### SERVERS ###

  escape('gangliat2b.iihe.ac.be'),	'hardware/machine/Virtual/virtual_kvm_gangliat2b',
  escape('test.wn.iihe.ac.be'), 'hardware/machine/Virtual/virtual_kvm_test',
  
  escape('vscvhost01.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111a',
  escape('vscvhost02.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111b',
  escape('vscvhost03.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111c',
  escape('vscvhost04.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111d',
  escape('vscvhost05.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112a',
  escape('vscvhost06.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112b',
  escape('vscvhost07.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112c',
  escape('vscvhost08.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112d',
  
  ### WORKERNODES ###

  escape('node19-101.wn.iihe.ac.be'),'hardware/machine/Virtual/virtual_kvm_node19-101',
  escape('node19-102.wn.iihe.ac.be'),'hardware/machine/Virtual/virtual_kvm_node19-102',

);
