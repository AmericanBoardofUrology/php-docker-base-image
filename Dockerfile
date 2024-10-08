FROM php:8.3-apache

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        apt-utils \
        curl \
        gnupg \
        inetutils-ping \
        less \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        locales \
        mariadb-client \
        nano \
        postfix \
        unixodbc \
        unixodbc-dev \
        unzip \
        wget \
        zlib1g-dev

ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/mozilla.pem

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN service postfix start
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
RUN curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update

ENV ACCEPT_EULA=Y
RUN apt-get install -y msodbcsql18 mssql-tools18
RUN apt-get install -y libgssapi-krb5-2

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN . ~/.bashrc

RUN docker-php-ext-install \
    gd \
    mysqli \
    opcache \
    pdo \
    pdo_mysql \
    zip
RUN pear config-set php_ini `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` system

RUN pecl install \
    sqlsrv-5.10.1 \
    pdo_sqlsrv-5.10.1 \
    xdebug

COPY php.ini /usr/local/etc/php/

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
