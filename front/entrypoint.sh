#!/bin/sh
set -e

cp /app/nginx.conf /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
