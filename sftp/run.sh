#!/bin/ash -e
cp /host_keys/* /etc/ssh/
for key in $(grep ^HostKey /etc/ssh/sshd_config | awk '{ print $2 }'); do
    if [ ! -f "$key" ]; then
        echo "missing $key -- run generate-host-keys"
        exit 1
    fi
done
update-users
exec /usr/sbin/sshd -D -e
