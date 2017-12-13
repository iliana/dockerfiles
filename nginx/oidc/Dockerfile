FROM alpine:edge as lua-builder
RUN apk update && apk upgrade && apk add git gcc luajit-dev make musl-dev
RUN mkdir -p /buildroot/usr/lib/lua/5.1 /buildroot/usr/share/lua/5.1
WORKDIR /usr/src
RUN git clone https://github.com/openresty/lua-cjson && cd lua-cjson \
 && git reset --hard bcbbb53bf2066c64614127f361e158970a14cab2 # 2.1.0.6rc2
RUN make -C lua-cjson LUA_INCLUDE_DIR=/usr/include/luajit-2.1 \
 && cp -v lua-cjson/cjson.so /buildroot/usr/lib/lua/5.1/
RUN git clone https://github.com/openresty/lua-resty-string && cd lua-resty-string \
 && git reset --hard 6c8bf6c01e401699e5bdd5fb208707c5ff62b211 # v0.10
RUN git clone https://github.com/pintsized/lua-resty-http && cd lua-resty-http \
 && git reset --hard b5f955961e42873725a345b752bc38ddad6c5203 # v0.11
RUN git clone https://github.com/bungle/lua-resty-session && cd lua-resty-session \
 && git reset --hard e13413b98838fffb9125af66a508b63dda2ab0d5 # v2.19
RUN git clone https://github.com/SkyLothar/lua-resty-jwt && cd lua-resty-jwt \
 && git reset --hard ee1d024071f872e2b5a66eaaf9aeaf86c5bab3ed # v0.1.11
RUN git clone https://github.com/jkeys089/lua-resty-hmac && cd lua-resty-hmac \
 && git reset --hard 989f601acbe74dee71c1a48f3e140a427f2d03ae
RUN git clone https://github.com/pingidentity/lua-resty-openidc && cd lua-resty-openidc \
 && git reset --hard d4ae56acc758606b8735220d3943c913569ea885 # v1.5.1
RUN cp -rv \
        lua-resty-string/lib/* \
        lua-resty-http/lib/* \
        lua-resty-session/lib/* \
        lua-resty-jwt/lib/* \
        lua-resty-hmac/lib/* \
        lua-resty-openidc/lib/* \
        /buildroot/usr/share/lua/5.1/

FROM ilianaw/nginx
COPY --from=lua-builder /buildroot/ /
