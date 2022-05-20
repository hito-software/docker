#!/usr/bin/env sh

if [[ "$APP_ENV" == "production" ]]; then
  php artisan queue:work --sleep=3 --tries=3 --timeout=300
else
  php artisan queue:listen --sleep=3 --tries=3 --timeout=300
fi
