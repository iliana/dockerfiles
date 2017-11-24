#!/bin/sh
IMAP_USER="${IMAP_USER-user}"
if [ -z "$IMAP_PASS" ]; then
    IMAP_PASS="$(tr -dc '[:alnum:][:punct:]' </dev/urandom | head -c 20)"
fi
UID="${UID-1000}"
GID="${GID-${UID-1000}}"

openssl req -newkey rsa:2048 -sha256 -x509 -nodes -subj '/CN=mail-archive/' -out /etc/ssl/dovecot/server.pem -keyout /etc/ssl/dovecot/server.key -days 365

cat <<EOF
IMAP username: $IMAP_USER
IMAP password: $IMAP_PASS
Maildir UID/GID: $UID/$GID
EOF
echo "$IMAP_USER:$(echo -e "$IMAP_PASS\n$IMAP_PASS" | doveadm pw -s SHA512-CRYPT):$UID:$GID::/mail::" >/etc/dovecot/users

exec dovecot -F
