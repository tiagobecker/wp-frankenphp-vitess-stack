FROM dunglas/frankenphp:1-php8.4-bookworm

# ---------------------------------------------------------
# Dependências de sistema necessárias para extensões PHP
# ---------------------------------------------------------
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    unzip \
    tar \
    git \
    openssl \
    mariadb-client \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    libmagickwand-dev \
    imagemagick \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libxml2-dev \
    g++ \
    make \
    autoconf \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# Instala extensões PHP obrigatórias manualmente
# ---------------------------------------------------------

# GD com suporte a freetype/jpeg/webp
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

RUN docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    zip \
    exif \
    pdo_mysql \
    mysqli \
    opcache

# ---------------------------------------------------------
# Extensões via PECL: Imagick + Redis
# ---------------------------------------------------------
RUN pecl install imagick && docker-php-ext-enable imagick
RUN pecl install redis && docker-php-ext-enable redis

# ---------------------------------------------------------
# Composer
# ---------------------------------------------------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ---------------------------------------------------------
# Configurações e arquivos
# ---------------------------------------------------------
COPY php.ini /usr/local/etc/php/
COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY wp-cli.yaml /etc/wp-cli.yaml

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /app/public

EXPOSE 80
EXPOSE 443

CMD ["/bin/bash", "-c", "entrypoint.sh && frankenphp run --config /etc/caddy/Caddyfile"]
