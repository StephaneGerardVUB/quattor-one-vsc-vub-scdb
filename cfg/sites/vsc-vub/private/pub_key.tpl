template private/pub_key;

include {'components/filecopy/config'};

variable CONTENTS = <<EOF;

EOF
"/software/components/filecopy/services" =
  npush(escape("/root/.ssh/authorized_keys"),
        nlist("config",CONTENTS));