#! /bin/sh 

set -e

rm -r /var/www/html/setup 

exec /usr/sbin/apachectl -D FOREGROUND
