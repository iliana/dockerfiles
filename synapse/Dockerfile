FROM fedora:25

RUN SYNAPSE_VERSION="0.19.1" && BUILD_PKGS="redhat-rpm-config libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel lcms2-devel libwebp-devel tcl-devel tk-devel gcc gcc-c++ python-devel openssl-devel" \
 && dnf install -y python openssl python-setuptools python-cffi python-pillow python-lxml python-psycopg2 $BUILD_PKGS \
 && pip install https://github.com/matrix-org/synapse/archive/v$SYNAPSE_VERSION.tar.gz \
 && dnf remove -y $BUILD_PKGS \
 && rm -rf /root/.cache \
 && rm -rf /var/cache/dnf/*
VOLUME ["/data"]
CMD ["python", "-m", "synapse.app.homeserver", "--config-path", "/data/homeserver.yaml"]
