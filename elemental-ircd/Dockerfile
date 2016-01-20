FROM alpine:latest
MAINTAINER Ian Weller <ianweller@buttslol.net>
WORKDIR /home/ircd
VOLUME /home/ircd/run/etc /home/ircd/run/logs
ENTRYPOINT ["/home/ircd/run/bin/ircd", "-foreground"]

ENV ELEMENTAL_VERSION=6.6.3

RUN BUILD_PKGS="curl tar gcc make musl-dev bison flex openssl-dev file" \
 && apk add --update openssl \
 && apk add --update $BUILD_PKGS \
 && addgroup -S -g 1000 ircd && adduser -SDh /home/ircd -G ircd -s /sbin/nologin -u 1000 ircd \
 && mkdir /home/ircd/src && cd /home/ircd/src \
 && curl -L https://github.com/Elemental-IRCd/elemental-ircd/archive/elemental-ircd-$ELEMENTAL_VERSION.tar.gz | tar xz --strip-components=1 \
 && ./configure --prefix=/home/ircd/run && make install \
 && apk del --rdepends $BUILD_PKGS \
 && rm -r /home/ircd/src /home/ircd/run/etc/* \
 && chown -R ircd /home/ircd/run

USER ircd
