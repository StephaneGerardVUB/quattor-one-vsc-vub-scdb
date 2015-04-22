template config/one_build_rubygems;

# packages required to compile the gems
'/software/packages/{gcc}' ?= dict();
'/software/packages/{rubygem-rake}' ?= dict();
'/software/packages/{libxml2-devel}' ?= dict();
'/software/packages/{libxslt-devel}' ?= dict();
'/software/packages/{gcc-c++}' ?= dict();
'/software/packages/{sqlite-devel}' ?= dict();
'/software/packages/{curl-devel}' ?= dict();
'/software/packages/{mysql-devel}' ?= dict();
'/software/packages/{ruby-devel}' ?= dict();
'/software/packages/{make}' ?= dict();

# Instead of running manually /usr/share/one/install_gems, we
# will use a modified version of this script that has been made
# unattended. This script will copied and execute with ncm-download.
include 'components/download/config';
'/software/components/download/active' = true;
'/software/components/download' = dict(
	'server',	'qclig.wn.iihe.ac.be',
	'proto',	'https',
);
'/software/components/download/files' = npush(
	escape('/usr/share/one/unattended_install_gems_rhel'), dict(
		'href',		'https://qclig.wn.iihe.ac.be:444/files/unattended_install_gems_rhel',
		'post',		'/usr/bin/ruby',
		'perm',		'755',
		'cacert',	'/etc/ipa/quattor/certs/ca.pem',
		'cert',		'/etc/ipa/quattor/certs/hostcert.pem',
		'key',		'/etc/ipa/quattor/certs/hostkey.pem',
	),
);
