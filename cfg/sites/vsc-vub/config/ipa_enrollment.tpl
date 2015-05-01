template config/ipa_enrollment;

#This template takes the needed actions to enroll a machine into our local Kerberos realm.
#Before including this script into a machine profile, you must create an instance for it in freeipa, and set a one-time password.
#The OTP (one-time password) to use is the one hidden in private/passwd.tpl... (for the dummies : it is not 'dummy' ;-)
#Enrollment is only possible for machines that belong to the private network (the Kerberos realm is only for private).

"/software/packages/{ipa-client}" ?= nlist();

variable IPA_DOMAIN = "wn.iihe.ac.be";
variable IPA_SERVER = "freeipa.wn.iihe.ac.be";
variable IPA_HOSTNAME = HOSTNAME + "." + IPA_DOMAIN;
variable IPA_REALM = "WN.IIHE.AC.BE";
variable IPA_CERT_LABEL = "IPA Machine Certificate - " + IPA_HOSTNAME;

variable IPA_CCM_CA = value('/software/components/ccm/ca_file');
variable IPA_CCM_HOSTCERT = value('/software/components/ccm/cert_file');
variable IPA_CCM_HOSTKEY = value('/software/components/ccm/key_file');
#variable IPA_CCM_CA = '/etc/ipa/quattor/certs/ca.pem';
#variable IPA_CCM_HOSTCERT = '/etc/ipa/quattor/certs/hostcert.pem';
#variable IPA_CCM_HOSTKEY = '/etc/ipa/quattor/certs/hostkey.pem';


variable CONTENTS = <<EOF;
#!/bin/bash
EOF

variable CONTENTS = CONTENTS + "ipa-client-install --domain=" + IPA_DOMAIN + 
                               " --password="+IPA_OTP +
                               " --unattended --realm="+ IPA_REALM +
                               " --server=" + IPA_SERVER + "\n";

variable CONTENTS = CONTENTS + <<EOF;
mkdir -p /etc/ipa/quattor/certs
EOF

variable CONTENTS = CONTENTS + "certutil -L -d /etc/pki/nssdb -a -n 'IPA CA' > " + IPA_CCM_CA + "\n"; 

variable CONTENTS = CONTENTS + "certutil -L -d /etc/pki/nssdb -a -n '" + IPA_CERT_LABEL + "' > "+ IPA_CCM_HOSTCERT + "\n";

variable CONTENTS = CONTENTS + "certutil -K -d /etc/pki/nssdb -a -n '" + IPA_CERT_LABEL + "'\n";

variable CONTENTS = CONTENTS + "pk12util -o keys.p12 -n '" + IPA_CERT_LABEL + "' -d /etc/pki/nssdb -W ''\n";

variable CONTENTS = CONTENTS + "openssl pkcs12 -in keys.p12 -out " + IPA_CCM_HOSTKEY + " -nodes -password pass:''\n";

variable CONTENTS = CONTENTS + "chmod 600 "+ IPA_CCM_HOSTKEY + "\n";

variable CONTENTS = CONTENTS + <<EOF;
rm -f keys.p12
EOF

"/software/components/filecopy/services" =
  npush(escape("/root/ipa_enrollment.sh"),
        nlist("config",CONTENTS,
        	  "restart","ls -al /root/ipa_enrollment.sh",
              "perms","0755"));

