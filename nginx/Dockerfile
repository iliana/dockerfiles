FROM alpine:edge
MAINTAINER Ian Weller <ianweller@buttslol.net>

RUN apk upgrade --no-cache && apk add --no-cache nginx \
 && mkdir /run/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
CMD ["nginx", "-g", "daemon off;"]
