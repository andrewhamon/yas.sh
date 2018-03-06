FROM openresty/openresty:xenial
RUN apt-get update && apt-get install -y ruby stunnel4

RUN luarocks install lua-resty-auto-ssl
RUN mkdir /etc/resty-auto-ssl

COPY ssl/resty-auto-ssl-fallback.crt /etc/ssl/resty-auto-ssl-fallback.crt
COPY ssl/resty-auto-ssl-fallback.key /etc/ssl/resty-auto-ssl-fallback.key

COPY stunnel.conf.erb /etc/stunnel/stunnel.conf.erb
COPY start_nginx.sh /usr/local/bin/start_nginx
COPY lookup.lua /usr/local/openresty/nginx/lookup.lua
COPY nginx.conf.erb /usr/local/openresty/nginx/conf/nginx.conf.erb
COPY html /usr/local/openresty/nginx/html

EXPOSE 80 443

CMD start_nginx
