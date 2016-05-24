Serves the contents of /data to users over SSH File Transfer Protocol.

## Instructions

Populate `/path/to/user_keys` with public keys of users you want to have access:

```
$ ls /path/to/user_keys
alice  bob
$ cat /path/to/user_keys/alice
ssh-rsa AAAA... alice@wonderland
```

Generate some host keys:

```
$ docker run --rm -v /path/to/host_keys:/host_keys ianweller/sftp generate-host-keys
```

Run the service:

```
$ docker run -d --name sftp -p 2222:22 \
    -v /path/to/host_keys:/host_keys:ro \
    -v /path/to/user_keys:/user_keys:ro \
    -v /var/data:/data \
    ianweller/sftp
```

You can add, update, or remove keys and run `update-users`:

```
$ docker exec sftp getent passwd | grep ':100[0-9]:'
alice:x:1000:1000::/data:/sbin/nologin
bob:x:1001:1001::/data:/sbin/nologin
$ rm /path/to/user_keys/alice
$ curl https://github.com/ghost.keys > /path/to/user_keys/ghost
$ docker exec sftp update-users
$ docker exec sftp getent passwd | grep ':100[0-9]:'
bob:x:1001:1001::/data:/sbin/nologin
ghost:x:1002:1002::/data:/sbin/nologin
```
