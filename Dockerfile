FROM php:8.1.5-fpm-alpine3.15

ENV MAGICK_HOME=/usr

COPY .docker/docker-php-ext-get /usr/local/bin/

RUN apk add --no-cache --update nginx supervisor git ffmpeg imagemagick-dev imagemagick vim nodejs npm \
    && apk add --no-cache --update --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache --update \
        imap-dev \
        openssl-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libraw-dev \
        libzip-dev \
    && chmod +x /usr/local/bin/docker-php-ext-get \
    && docker-php-source extract \
    && docker-php-ext-get xdebug 3.1.4 \
    && docker-php-ext-get redis 5.3.7 \
    && docker-php-ext-get imagick 3.7.0 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap-ssl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) \
        redis \
        xdebug \
        imagick \
        pdo_mysql \
        bcmath \
        gd \
        zip \
        exif \
        opcache \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable redis \
    && docker-php-source delete \
    && apk del .build-deps \
    && mkdir -p /run/nginx \
    && addgroup www-data users

EXPOSE 80

ENV APP_DIRECTORY="/var/www/html" \
    PHP_OPCACHE_ENABLE="1" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_XDEBUG_ENABLE="0" \
    PHP_XDEBUG_MODE="develop,debug" \
    PHP_XDEBUG_HOST="127.0.0.1" \
    PHP_XDEBUG_PORT="9003" \
    PHP_XDEBUG_IDEKEY="" \
    PHP_XDEBUG_START_WITH_REQUEST="default" \
    PHP_XDEBUG_DISCOVER_CLIENT_HOST="1" \
    PHP_XDEBUG_CLIENT_DISCOVERY_HEADER="" \
    PHP_XDEBUG_LOG="" \
    PHP_IDE_CONFIG="" \
    AUTOSTART_COMPOSER="0" \
    AUTOSTART_MIGRATIONS="1" \
    AUTOSTART_QUEUE="1" \
    AUTOSTART_SEED_PERMISSIONS="1" \
    AUTOSTART_WEBSOCKETS="1"

COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

COPY .docker/autostart-composer.sh /usr/local/bin/autostart-composer
COPY .docker/autostart-migrations.sh /usr/local/bin/autostart-migrations
COPY .docker/autostart-queue.sh /usr/local/bin/autostart-queue
COPY .docker/autostart-seed-permissions.sh /usr/local/bin/autostart-seed-permissions
COPY .docker/autostart-websockets.sh /usr/local/bin/autostart-websockets
COPY .docker/cronjob /var/spool/cron/crontabs/root
COPY .docker/fix-permissions.sh /usr/local/bin/fix-permissions
COPY .docker/nginx.conf /etc/nginx/http.d/default.conf
COPY .docker/php.ini /usr/local/etc/php/conf.d/custom-php.ini
COPY .docker/start-php-fpm.sh /usr/local/bin/start-php-fpm
COPY .docker/start-queue.sh /usr/local/bin/start-queue
COPY .docker/start-supervisor.sh /usr/local/bin/start-supervisor
COPY .docker/supervisord.conf /etc/supervisord.conf

RUN chmod +x /usr/local/bin/autostart-composer \
    && chmod +x /usr/local/bin/autostart-migrations \
    && chmod +x /usr/local/bin/autostart-queue \
    && chmod +x /usr/local/bin/autostart-seed-permissions \
    && chmod +x /usr/local/bin/autostart-websockets \
    && chmod +x /usr/local/bin/fix-permissions \
    && chmod +x /usr/local/bin/start-php-fpm \
    && chmod +x /usr/local/bin/start-queue \
    && chmod +x /usr/local/bin/start-supervisor \
    && /usr/local/bin/fix-permissions

HEALTHCHECK CMD curl --fail http://localhost/api/health || exit 1

ENTRYPOINT ["start-supervisor"]
