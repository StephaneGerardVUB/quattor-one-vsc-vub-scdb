#
# Generated by RepositoryTask on 2/16/14 6:25 PM
#
# name = sl6x_x86_64_updates
# owner = grid_admin@listserv.vub.ac.be
# url = http://yum.iihe.ac.be/cb9/sl6x-x86_64_updates
#

structure template repository/snapshot/sl6x_x86_64_updates;

"name" = "sl6x_x86_64_updates";
"owner" = "grid_admin@listserv.vub.ac.be";
"protocols" = list(
  nlist("name","http",
        "url","http://yum.iihe.ac.be/cb9/"+REPO_YUM_SNAPSHOT_DATE['sl6x_x86_64_updates']+"/sl6x-x86_64_updates")
);
