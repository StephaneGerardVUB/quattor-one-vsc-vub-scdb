template config/os_base;

variable UNNEEDED_SERV = list('yum','yum-autoupdate','yum-updatesd','apt','cups','cups-config-daemon','hpoj','pcmcia','zhm','messagebus','kudzu','cpuspeed','isdn');
"/software/components/chkconfig/service/" = {
  list = UNNEEDED_SERV;
  if (exists(SELF) && is_dict(SELF)) {
    tbl = SELF;
  } else {
    tbl = dict();
  }; 
  ok = first(list,k,v);
  while (ok) {
	tbl[v] = dict(
		"off","",
		"startstop",true,
		);
    ok = next(list,k,v);
  };		
  return(tbl);
 }; 
 


