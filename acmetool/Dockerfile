FROM alpine:latest
WORKDIR /usr/local/bin
VOLUME /var/lib/acme
ENTRYPOINT ["/usr/local/bin/acmetool"]

RUN ACME_VERSION="0.0.59" \
 && BUILD_PKGS="curl tar" \
 && apk add --no-cache ca-certificates $BUILD_PKGS \
 && mkdir -p /usr/libexec/acme/hooks \
 && curl -L https://github.com/hlandau/acme/releases/download/v$ACME_VERSION/acmetool-v$ACME_VERSION-linux_amd64.tar.gz | tar xz --strip-components=2 acmetool-v$ACME_VERSION-linux_amd64/bin/acmetool \
 && apk del --rdepends $BUILD_PKGS
