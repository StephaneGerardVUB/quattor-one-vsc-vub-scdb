##
## this is a template that should contain all sensitive info (eg passwds etc) that you might want to see encrypted
##
template private/passwd;

## "/software/components/accounts/rootpwd" 
## use openssl passwd -1 to generate it
variable ROOT_PASSWD ?= "dummy";

## "/software/components/aii/osinstall/options/rootpw" 
## is currently the same as the main passwd
variable AII_OSINSTALL_ROOTPW ?= "dummy";

## "/software/components/lcgbdii/passwd" (pro_lcg_config_site)
variable BDII_PASSWD ?= "dummy";

## pro_declaration_component_apel (DBPassword) (pro_lcg_config_site)
## APELDB_PWD in pro_lcg2_config_apel_pbs and pro_lcg2_config_apel_rgma
variable APELDB_PWD ?= "dummy";
variable APEL_MYSQL_ADMINPWD ?= "dummy";

## "/software/components/rgmaserver/mysqlPwd" (pro_lcg_config_site pro_lcg2_service_rgma)
variable MYSQL_PASSWORD ?= "dummy";

## "/software/components/dblbconfig/dbPassword"
variable DBLB_PASSWD ?= "dummy";

## check for sslKeyPasswd=changeit in pro_lcg2_service_edg_rgma_gin!!
variable RGMA_GIN_KEY_PASSWD ?= "dummy";

## glite/lfc/config;
#"/software/components/dpmlfc/options/lfc/db/password" ?= LFC_DB_PASSWD;
variable LFC_DB_PASSWD ?= "change me";
#"/software/components/dpmlfc/options/lfc/db/adminpwd" ?= LFC_DB_ADMINPASSWD;
variable LFC_DB_ADMINPASSWD ?= "change me";

## glite/lfc/config;
#"/software/components/dpmlfc/options/lfc/db/password" ?= LFC_USER_PASSWD;
variable LFC_USER_PASSWD ?= "dummy";
#"/software/components/dpmlfc/options/lfc/db/adminpwd" ?= LFC_ADMIN_PASSWD;
variable LFC_ADMIN_PASSWD ?= MYSQL_PASSWORD;


## check also for user passwds !!
## pro_lcg2_service_gridice_webserver (needs component or encrypted version of filecopy)

## "/software/components/glite/services/voms-server/parameters/voms.mysql.admin.password"
## "/software/components/glite/services/voms-server/voms/becms/" ("voms.mysql.admin.password","voms.db.user.password")
variable VOMS_PASSWORD ?= "dummy";
variable VOMS_DB_ADMINPASSWD ?= "dummy2";
variable VOMS_DB_USER_PASSWD ?= "dummy3";
variable VOMS_MYSQL_ADMINPWD = "dummy4";

## "/software/components/glite/services/lb/parameters/mysql.root.password" = WMSLB_MYSQL_PASSWORD;
## "/software/components/glite/services/wms/parameters/mysql.root.password" = WMSLB_MYSQL_PASSWORD;
variable WMSLB_MYSQL_PASSWORD ?= "dummy";

## WMSLB
variable LB_MYSQL_ADMINPWD = 'dummy';
variable WMS_DB_PWD = 'dummy';

## Oracle Passwd for oramon
variable ORAMON_PASSWD ?= "dummyy";

# Password for enrollment in our freeipa Kerberos realm
variable IPA_OTP ?= 'dummy';

# Password for OpenNebula ONE RPC password
variable ONE_RPC_PASSWORD ?= 'dummy';
