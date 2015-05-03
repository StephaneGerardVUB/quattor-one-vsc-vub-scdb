template site/databases;

# Defines the mapping between the full hostname and the IP
# address.
variable DB_IP = dict(

	### SERVERS ###
	
	escape('aiisrv.wn.iihe.ac.be'),'192.168.10.118',
	
	escape('vscvhost01.wn.iihe.ac.be'),'192.168.10.142',
	escape('vscvhost02.wn.iihe.ac.be'),'192.168.10.143',
	escape('vscvhost03.wn.iihe.ac.be'),'192.168.10.144',
	escape('vscvhost04.wn.iihe.ac.be'),'192.168.10.145',
	escape('vscvhost05.wn.iihe.ac.be'),'192.168.10.146',
	escape('vscvhost06.wn.iihe.ac.be'),'192.168.10.147',
	escape('vscvhost07.wn.iihe.ac.be'),'192.168.10.148',
	escape('vscvhost08.wn.iihe.ac.be'),'192.168.10.149',

	### VMs ###
	
	escape('vm1.wn.iihe.ac.be'),'192.168.52.1',

);

# Defines the mapping between the full hostname and the
# physical machine.
variable DB_MACHINE = dict(

	### SERVERS ###
	
	escape('vscvhost01.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111a',
	escape('vscvhost02.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111b',
	escape('vscvhost03.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111c',
	escape('vscvhost04.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2111d',
	escape('vscvhost05.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112a',
	escape('vscvhost06.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112b',
	escape('vscvhost07.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112c',
	escape('vscvhost08.wn.iihe.ac.be'), 'hardware/machine/HP_VSC_CLOUD_2013/hp2112d',
	
	### VMs ###

	escape('vm1.wn.iihe.ac.be'), 'hardware/machine/one/example',
);
