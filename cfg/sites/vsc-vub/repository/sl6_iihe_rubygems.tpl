#
# name = sl6_iihe_rubygems
# owner = support-iihe@ulb.ac.be
# url = http://yum.iihe.ac.be/cb9/sl6_ruby_gems
#

structure template repository/sl6_iihe_rubygems;

'name' = 'sl6_iihe_rubygems';
'owner' = 'support-iihe@ulb.ac.be';
'protocols' = list(
	nlist(
		'name',	'http',
        'url',	'http://yum.iihe.ac.be/cb9/sl6_ruby_gems'
        )
);