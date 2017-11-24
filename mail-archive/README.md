Provides an IMAP interface to a Dovecot [mdbox](https://wiki2.dovecot.org/MailboxFormat/dbox) volume.

Designed for running as a short-term, single-account IMAP server for importing email for archival and later searching via IMAP.

## Instructions

Run the container:

```
$ docker run -p 1993:993 \
    -v /path/to/maildir:/mail \
    ilianaw/mail-archive
```

You can override the IMAP username/password, UID, and GID with the environment variables `IMAP_USER`, `IMAP_PASS`, `UID`, and `GID`.
