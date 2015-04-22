template config/ssh;

include 'components/ssh/config';

'/software/components/ssh/daemon/options' = npush('PasswordAuthentication','no');
	
## breaks sshd
'/software/components/ssh/daemon/comment_options' = npush('AFSTokenPassing','yes');
'/software/components/ssh/daemon/comment_options' = npush('KerberosGetAFSToken','yes');
'/software/components/ssh/daemon/comment_options' = npush('KerberosTgtPassing','yes');
'/software/components/ssh/daemon/comment_options' = npush('TcpRcvBufPoll','yes');

## annoying
'/software/components/ssh/daemon/comment_options' = npush('Banner','/etc/issue.net');