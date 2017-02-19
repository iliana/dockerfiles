FROM alpine:latest
RUN NGINX_VERSION="1.11.10" && BORINGSSL_COMMIT="5c9d411e145d97698cdd12419edf581dfd9cd050" \
 && BUILDPKGS="cmake curl gcc g++ git gnupg go make musl-dev ninja pcre-dev perl zlib-dev" \
 && addgroup -S nginx && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && rm /etc/passwd- /etc/group- /etc/shadow- \
 && apk add --no-cache $BUILDPKGS pcre zlib \
 && curl -fSL -O "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" \
 && curl -fSL -O "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 # key 520A9993A1C052F8: public key "Maxim Dounin <mdounin@mdounin.ru>"
 # see https://nginx.org/en/pgp_keys.html
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B0F4253373F8F6F510D42178520A9993A1C052F8 \
 && gpg --batch --verify "nginx-$NGINX_VERSION.tar.gz.asc" "nginx-$NGINX_VERSION.tar.gz" \
 && rm -r "$GNUPGHOME" "nginx-$NGINX_VERSION.tar.gz.asc" \
 && tar xf "nginx-$NGINX_VERSION.tar.gz" && cd "nginx-$NGINX_VERSION" \
 && git clone https://boringssl.googlesource.com/boringssl && cd boringssl && git reset --hard "$BORINGSSL_COMMIT" \
 && mkdir build && cd build && cmake -GNinja -DCMAKE_BUILD_TYPE=Release .. && ninja && cd .. \
 && mkdir -p .openssl/lib && cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib/ \
 && ln -s ../include .openssl/ && cd .. \
 && ./configure --with-cc-opt="-Wno-incompatible-pointer-types" --user=nginx --group=nginx --with-openssl=boringssl \
        --prefix=/var/lib/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx/nginx.pid \
        --lock-path=/run/nginx/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-http_ssl_module \
        --with-http_v2_module \
        --without-http_access_module \
        --without-http_auth_basic_module \
        --without-http_autoindex_module \
        --without-http_browser_module \
        --without-http_empty_gif_module \
        --without-http_fastcgi_module \
        --without-http_geo_module \
        --without-http_memcached_module \
        --without-http_referer_module \
        --without-http_scgi_module \
        --without-http_split_clients_module \
        --without-http_ssi_module \
        --without-http_upstream_hash_module \
        --without-http_upstream_ip_hash_module \
        --without-http_upstream_zone_module \
        --without-http_userid_module \
        --without-http_uwsgi_module \
 && touch boringssl/.openssl/include/openssl/ssl.h && make && make install \
 && cat objs/ngx_modules.c \
 && cd / && rm -r "nginx-$NGINX_VERSION" "nginx-$NGINX_VERSION.tar.gz" \
 && apk del $BUILDPKGS \
 # forward request and error logs to docker log collector
 && ln -sf /dev/stdout /var/lib/nginx/logs/access.log \
 && ln -sf /dev/stderr /var/lib/nginx/logs/error.log
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
