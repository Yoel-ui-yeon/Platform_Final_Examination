FROM php:8.5-cli
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y git unzip curl \
    && docker-php-ext-install pdo pdo_mysql \
    && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
    && apt-get install -y symfony-cli \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer

COPY composer.json composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize

EXPOSE 8000
CMD ["symfony", "server:start", "--port=8000", "--no-tls", "--allow-all-ip"]