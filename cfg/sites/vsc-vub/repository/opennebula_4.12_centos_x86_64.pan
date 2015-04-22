#
# Generated by RepositoryTask on 4/5/15 1:44 PM
#
# name = opennebula_4.12_centos_x86_64
# owner = support@opennebula.org
# url = http://downloads.opennebula.org/repo/4.12/CentOS/6/x86_64/
#

structure template repository/opennebula_4.12_centos_x86_64;

'name' = 'opennebula_4.12_centos_x86_64';
'owner' = 'support@opennebula.org';
'protocols' = list(
  nlist('name','http',
        'url','http://downloads.opennebula.org/repo/4.12/CentOS/6/x86_64/')
);

"contents" = nlist(
# pkg = opennebula-4.11.80-1-x86_64
escape("opennebula-4.11.80-1-x86_64"),nlist("name","opennebula","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-4.12.0-1-x86_64
escape("opennebula-4.12.0-1-x86_64"),nlist("name","opennebula","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-common-4.11.80-1-x86_64
escape("opennebula-common-4.11.80-1-x86_64"),nlist("name","opennebula-common","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-common-4.12.0-1-x86_64
escape("opennebula-common-4.12.0-1-x86_64"),nlist("name","opennebula-common","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-debuginfo-4.11.80-1-x86_64
escape("opennebula-debuginfo-4.11.80-1-x86_64"),nlist("name","opennebula-debuginfo","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-debuginfo-4.12.0-1-x86_64
escape("opennebula-debuginfo-4.12.0-1-x86_64"),nlist("name","opennebula-debuginfo","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-flow-4.11.80-1-x86_64
escape("opennebula-flow-4.11.80-1-x86_64"),nlist("name","opennebula-flow","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-flow-4.12.0-1-x86_64
escape("opennebula-flow-4.12.0-1-x86_64"),nlist("name","opennebula-flow","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-gate-4.11.80-1-x86_64
escape("opennebula-gate-4.11.80-1-x86_64"),nlist("name","opennebula-gate","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-gate-4.12.0-1-x86_64
escape("opennebula-gate-4.12.0-1-x86_64"),nlist("name","opennebula-gate","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-java-4.11.80-1-x86_64
escape("opennebula-java-4.11.80-1-x86_64"),nlist("name","opennebula-java","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-java-4.12.0-1-x86_64
escape("opennebula-java-4.12.0-1-x86_64"),nlist("name","opennebula-java","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-node-kvm-4.11.80-1-x86_64
escape("opennebula-node-kvm-4.11.80-1-x86_64"),nlist("name","opennebula-node-kvm","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-node-kvm-4.12.0-1-x86_64
escape("opennebula-node-kvm-4.12.0-1-x86_64"),nlist("name","opennebula-node-kvm","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-ruby-4.11.80-1-x86_64
escape("opennebula-ruby-4.11.80-1-x86_64"),nlist("name","opennebula-ruby","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-ruby-4.12.0-1-x86_64
escape("opennebula-ruby-4.12.0-1-x86_64"),nlist("name","opennebula-ruby","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-server-4.11.80-1-x86_64
escape("opennebula-server-4.11.80-1-x86_64"),nlist("name","opennebula-server","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-server-4.12.0-1-x86_64
escape("opennebula-server-4.12.0-1-x86_64"),nlist("name","opennebula-server","version","4.12.0-1","arch","x86_64"),
# pkg = opennebula-sunstone-4.11.80-1-x86_64
escape("opennebula-sunstone-4.11.80-1-x86_64"),nlist("name","opennebula-sunstone","version","4.11.80-1","arch","x86_64"),
# pkg = opennebula-sunstone-4.12.0-1-x86_64
escape("opennebula-sunstone-4.12.0-1-x86_64"),nlist("name","opennebula-sunstone","version","4.12.0-1","arch","x86_64"),
);
