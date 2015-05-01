unique template config/one/rubygems;

# Install ruby gems packages required by the frontend

# OS Centos6/SL6
'/software/packages/' = if ( OS_VERSION_PARAMS['majorversion'] == '6' ) {
	npush(
		escape('rubygem-zendesk_api'), dict(),
		escape('rubygem-treetop'), dict(),
		escape('rubygem-amazon-ec2'), dict(),
		escape('rubygem-aws-sdk'), dict(),
		escape('rubygem-builder'), dict(),
		escape('rubygem-curb'), dict(),
		escape('rubygem-mini_portile'), dict(),
		escape('rubygem-mysql'), dict(),
		escape('rubygem-net-ldap'), dict(),
		escape('rubygem-ox'), dict(),
		escape('rubygem-parse-cron'), dict(),
		escape('rubygem-rack-protection'), dict(),
		escape('rubygem-sqlite3'), dict(),
		escape('rubygem-tilt'), dict(),
		escape('rubygem-trollop'), dict(),
		escape('rubygem-xml-simple'), dict(),
		escape('rubygem-zendesk_api'), dict(),
	)
} else {
	SELF;
};

# OS Centos7/SL7
'/software/packages/' = if ( OS_VERSION_PARAMS['majorversion'] == '7' ) {
	npush(
		escape('rubygem-nokogiri'), dict(),
		escape('rubygem-json'), dict(),
		escape('rubygem-rack'), dict(),
		escape('rubygem-sinatra'), dict(),
		escape('rubygem-thin'), dict(),
		escape('rubygem-zendesk_api'), dict(),
		escape('rubygem-sqlite3'), dict(),
		escape('rubygem-sequel'), dict(),
		escape('rubygem-amazon-ec2'), dict(),
		escape('rubygem-uuidtools'), dict(),
		escape('rubygem-curb'), dict(),
		escape('rubygem-net-ldap'), dict(),
		escape('rubygem-builder'), dict(),
		escape('rubygem-trollop'), dict(),
		escape('rubygem-treetop'), dict(),
		escape('rubygem-parse-cron'), dict(),
		escape('rubygem-aws-sdk'), dict(),
		escape('rubygem-ox'), dict(),
		escape('rubygem-mysql'), dict(),
		escape('rubygem-softlayer_api'), dict(),
		escape('rubygem-configparser'), dict(),
		escape('rubygem-azure'), dict(),
	)
} else {
	SELF;
};