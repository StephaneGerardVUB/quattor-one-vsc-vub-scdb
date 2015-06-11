unique template features/one_frontend/one_auth;

'/software/components/filecopy/services' =
  npush(escape("/var/lib/one/.one/one_auth.new"),
        dict('config',format("oneadmin:%s\n", ONE_RPC_PASSWORD),
              'owner','oneadmin:oneadmin',
              'perms', '0600'));

