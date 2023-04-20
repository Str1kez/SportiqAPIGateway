FROM openresty/openresty:1.21.4.1-0-alpine

COPY ./third_party/resty /usr/local/openresty/lualib/resty/

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
