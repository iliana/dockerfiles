FROM fedora:25
COPY start.sh 3ADA06EDC753D11E.asc /
RUN SYNAPSE_VERSION="0.21.1" && BUILD_PKGS="redhat-rpm-config libfaketime git-core libtiff-devel libjpeg-devel libzip-devel freetype-devel lcms2-devel libwebp-devel tcl-devel tk-devel lcms2-devel libwebp-devel tcl-devel tk-devel gcc gcc-c++ python-devel openssl-devel" \
 && echo "%_install_langs en" > /etc/rpm/macros.image-language-conf \
 && dnf install --setopt=deltarpm=0 --setopt=tsflags=nodocs -y python openssl python-setuptools python-cffi python-pillow python-lxml python-psycopg2 $BUILD_PKGS \
 && git clone --branch v$SYNAPSE_VERSION https://github.com/matrix-org/synapse && cd synapse \
 && gpg2 --import </3ADA06EDC753D11E.asc && git config gpg.program gpg2 && faketime "$(git tag --format='%(taggerdate:iso)' -l v$SYNAPSE_VERSION)" git tag -v v$SYNAPSE_VERSION \
 && python setup.py sdist && pip install dist/matrix-synapse-$SYNAPSE_VERSION.tar.gz \
 && cd .. && rm -rf synapse && dnf remove -y $BUILD_PKGS \
 && rm -rf /root/.cache /root/.gnupg /var/cache/dnf/* \
 && groupadd -r -g 797 docker && useradd -r -g docker -u 797 docker \
 && mkdir /data && chown docker:docker /data
VOLUME ["/data"]
EXPOSE 8448
CMD /start.sh
USER docker
