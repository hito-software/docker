#!/usr/bin/env sh

CONFIG="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"

if [[ "$PHP_XDEBUG_ENABLE" == 1 ]]; then
  if test -f "$CONFIG.bak"; then
    mv "$CONFIG.bak" "$CONFIG"
  fi
else
  if test -f "$CONFIG"; then
    mv "$CONFIG" "$CONFIG.bak"
  fi
fi

(cd /var/www/html && php artisan storage:link)

php-fpm
