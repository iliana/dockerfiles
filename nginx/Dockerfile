FROM alpine:edge as boringssl-builder
RUN apk update && apk add cmake gcc g++ git go ninja perl
RUN mkdir /usr/src && git clone https://boringssl.googlesource.com/boringssl /usr/src/boringssl \
 && cd /usr/src/boringssl && git reset --hard ba8f1864c15ec938ce0851f416663511c89f454a
WORKDIR /usr/src/boringssl
COPY boringssl-*.patch /usr/src/
RUN git -c user.name=builder -c user.email=builder@docker.invalid am /usr/src/boringssl-*.patch
RUN mkdir build && cd build && cmake -GNinja -DCMAKE_BUILD_TYPE=Release ..
RUN cd build && ninja run_tests

FROM alpine:edge as nginx-builder
RUN apk update && apk add curl gcc gnupg make musl-dev pcre-dev zlib-dev
ENV NGINX_VERSION="1.13.6"
WORKDIR /usr/src
RUN curl -sSL -O "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" \
              -O "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc"
# key 520A9993A1C052F8: public key "Maxim Dounin <mdounin@mdounin.ru>"
# see https://nginx.org/en/pgp_keys.html
COPY mdounin.asc /usr/src/
RUN gpg --import /usr/src/mdounin.asc \
 && gpg --batch --verify "nginx-$NGINX_VERSION.tar.gz.asc" "nginx-$NGINX_VERSION.tar.gz" \
 && gpg-connect-agent killagent /bye
RUN tar xf "nginx-$NGINX_VERSION.tar.gz"
WORKDIR /usr/src/nginx-$NGINX_VERSION
COPY --from=boringssl-builder /usr/src/boringssl/build/crypto/libcrypto.a /usr/src/boringssl/build/ssl/libssl.a \
        boringssl/.openssl/lib/
COPY --from=boringssl-builder /usr/src/boringssl/include/openssl/* boringssl/.openssl/include/openssl/
COPY nginx-200-k.patch /usr/src/
RUN patch -p1 </usr/src/nginx-200-k.patch
RUN CC="cc -flto" ./configure --user=nginx --group=nginx --with-openssl=boringssl \
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
        --without-http_uwsgi_module
RUN touch boringssl/.openssl/include/openssl/ssl.h \
 && make -j && cat objs/ngx_modules.c
RUN make install DESTDIR=/buildroot
WORKDIR /buildroot/usr/sbin
RUN mkdir -p /buildroot/usr/lib/debug/usr/sbin
RUN objcopy --only-keep-debug --compress-debug-sections nginx nginx.debug \
 && objcopy --add-gnu-debuglink=nginx.debug nginx \
 && mv nginx.debug /buildroot/usr/lib/debug/usr/sbin/ && strip nginx

FROM alpine:edge
COPY --from=nginx-builder /buildroot/ /
RUN apk add --no-cache pcre zlib \
 && addgroup -S nginx && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
 && rm /etc/passwd- /etc/group- /etc/shadow- \
 && mkdir -p /run/nginx /var/lib/nginx/logs \
 && ln -sf /dev/stdout /var/lib/nginx/logs/access.log \
 && ln -sf /dev/stderr /var/lib/nginx/logs/error.log \
 && /usr/sbin/nginx -v
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
