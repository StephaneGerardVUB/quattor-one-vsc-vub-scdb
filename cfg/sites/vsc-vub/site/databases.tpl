template site/databases;

# Defines the mapping between the full hostname and the IP
# address.
variable DB_IP = dict(

  ### SERVERS ###

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
