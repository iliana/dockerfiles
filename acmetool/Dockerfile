FROM alpine:latest
MAINTAINER Ian Weller <ianweller@buttslol.net>
WORKDIR /usr/local/bin
VOLUME /var/lib/acme
ENTRYPOINT ["/usr/local/bin/acmetool"]

RUN ACME_VERSION="0.0.51" \
 && BUILD_PKGS="curl tar python3-dev gcc musl-dev libffi-dev openssl-dev" \
 && apk add --no-cache python3 bind-tools $BUILD_PKGS \
 && mkdir -p /usr/libexec/acme/hooks \
 && pyvenv /usr/libexec/acme/venv-dns.hook \
 && /usr/libexec/acme/venv-dns.hook/bin/pip install -U pip setuptools \
 && /usr/libexec/acme/venv-dns.hook/bin/pip install requests[security] \
 && curl -L https://github.com/hlandau/acme/releases/download/v$ACME_VERSION/acmetool-v$ACME_VERSION-linux_amd64.tar.gz | tar xz --strip-components=2 acmetool-v$ACME_VERSION-linux_amd64/bin/acmetool \
 && curl -L https://github.com/yinguanhao/acme-dns-hook-cloudflare/raw/master/dns.hook \
  | sed -e 's%^#!/usr/bin/python3$%#!/usr/libexec/acme/venv-dns.hook/bin/python3%' -e 's/^# EMAIL =.*$/import os; EMAIL = os.getenv("ACME_CLOUDFLARE_EMAIL")/' -e 's/^# KEY =.*$/KEY = os.getenv("ACME_CLOUDFLARE_KEY")/' > /usr/libexec/acme/hooks/dns.hook \
 && chmod 0755 /usr/libexec/acme/hooks/dns.hook \
 && apk del --rdepends $BUILD_PKGS
