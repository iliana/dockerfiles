FROM fedora:25
COPY start.sh 3ADA06EDC753D11E.asc /
RUN SYNAPSE_VERSION="0.19.3" && BUILD_PKGS="redhat-rpm-config git-core libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel lcms2-devel libwebp-devel tcl-devel tk-devel gcc gcc-c++ python-devel openssl-devel" \
 && dnf install -y python openssl python-setuptools python-cffi python-pillow python-lxml python-psycopg2 $BUILD_PKGS \
 && git clone --branch v$SYNAPSE_VERSION https://github.com/matrix-org/synapse && cd synapse \
 && gpg2 --import </3ADA06EDC753D11E.asc && git config gpg.program gpg2 && git tag -v v$SYNAPSE_VERSION \
 && python setup.py sdist && pip install dist/matrix-synapse-$SYNAPSE_VERSION.tar.gz \
 && cd .. && rm -rf synapse && dnf remove -y $BUILD_PKGS \
 && rm -rf /root/.cache /root/.gnupg /var/cache/dnf/* \
 && groupadd -r -g 797 docker && useradd -r -g docker -u 797 docker \
 && mkdir /data && chown docker:docker /data
VOLUME ["/data"]
EXPOSE 8448
CMD /start.sh
USER docker
