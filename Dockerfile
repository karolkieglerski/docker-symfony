FROM php:7.1-fpm

ENV PROJECT symfony
ENV USER devel
ENV SYMFONY_V 2.8

RUN mkdir -p /usr/local/bin \
    && curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
    && chmod a+x /usr/local/bin/symfony

RUN apt-get update \
    && apt-get install -y \
    zlib1g-dev \
    libicu-dev \
    g++ \
    && apt-get clean

RUN docker-php-ext-install \
    opcache \
    intl

COPY conf/php.ini /usr/local/etc/php/

RUN groupadd -g 1000 $USER \
    && useradd -u 1000 -g 1000 $USER

RUN mkdir -p /var/www \
    && chown $USER /var/www

USER $USER

RUN cd /var/www \
    && symfony new $PROJECT $SYMFONY_V

VOLUME /var/www/$PROJECT
WORKDIR /var/www/$PROJECT