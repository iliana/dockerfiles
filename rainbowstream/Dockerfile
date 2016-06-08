FROM ianweller/py3
ENTRYPOINT ["rainbowstream"]
 
RUN BUILD_PKGS="gcc musl-dev python3-dev jpeg-dev zlib-dev" \
 && apk add --no-cache ca-certificates jpeg $BUILD_PKGS \
 && CFLAGS=-L/lib pip3 --no-cache-dir install rainbowstream \
 && cc -fPIC -shared -o /root/.image.so /usr/lib/python*/site-packages/rainbowstream/image.c \
 && apk del --rdepends $BUILD_PKGS
