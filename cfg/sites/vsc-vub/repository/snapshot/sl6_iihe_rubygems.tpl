#
# name = sl6_iihe_rubygems
# owner = support-iihe@ulb.ac.be
# url = http://yum.iihe.ac.be/cb9/sl6_ruby_gems
#

structure template repository/snapshot/sl6_iihe_rubygems;

'name' = 'sl6_iihe_rubygems';
'owner' = 'support-iihe@ulb.ac.be';
'protocols' = list(
	dict(
		'name',	'http',
        'url',	'http://yum.iihe.ac.be/cb9/' + REPO_YUM_SNAPSHOT_DATE['sl6_iihe_rubygems'] + '/sl6_ruby_gems'
	)
);