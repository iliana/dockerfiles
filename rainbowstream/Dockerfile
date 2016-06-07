FROM alpine:latest
ENTRYPOINT ["rainbowstream"]
 
RUN BUILD_PKGS="py-pip gcc musl-dev" \
 && apk add --no-cache ca-certificates python py-pillow py-setuptools $BUILD_PKGS \
 && pip install rainbowstream \
 && cc -fPIC -shared -o /root/.image.so /usr/lib/python2.7/site-packages/rainbowstream/image.c \
 && apk del --rdepends $BUILD_PKGS
