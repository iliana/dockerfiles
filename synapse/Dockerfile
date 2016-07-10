FROM alpine:edge
MAINTAINER Ian Weller <ianweller@buttslol.net>

RUN SYNAPSE_VERSION="0.16.1" && BUILD_PKGS="py-pip python-dev openssl-dev gcc make musl-dev" \
 && apk upgrade --no-cache && apk add --no-cache ca-certificates python openssl py-setuptools py-cffi py-pillow py-lxml $BUILD_PKGS \
 && pip install https://github.com/matrix-org/synapse/archive/v$SYNAPSE_VERSION.tar.gz \
 && apk del --rdepends $BUILD_PKGS \
 && rm -rf /root/.cache
VOLUME ["/data"]
CMD ["python", "-m", "synapse.app.homeserver", "--config-path", "/data/homeserver.yaml"]
