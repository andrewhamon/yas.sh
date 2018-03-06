#!/bin/sh

erb /etc/stunnel/stunnel.conf.erb > /etc/stunnel/stunnel.conf
erb /usr/local/openresty/nginx/conf/nginx.conf.erb > /usr/local/openresty/nginx/conf/nginx.conf

/usr/bin/stunnel && /usr/local/openresty/bin/openresty
