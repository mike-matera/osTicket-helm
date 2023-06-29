FROM docker.io/php:8.2-apache as base

RUN apt update -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl git default-mysql-client

# Need kubectl to support the installer on Kubernetes.
RUN cd /usr/bin \
    && curl -LO https://dl.k8s.io/release/v1.26.3/bin/linux/amd64/kubectl \
    && chmod 0555 kubectl 

# Force the logs to stdout/stderr 
RUN ln -sfT /dev/stderr "/var/log/apache2/error.log" \
    && ln -sfT /dev/stdout "/var/log/apache2/access.log" \
    && ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log"; 

# Install PHP extensions
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
        zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
		libjpeg62-turbo-dev libpng-dev libc-client2007e-dev libkrb5-dev libc-client-dev \
        libkrb5-dev libicu-dev libmemcached-dev libssl-dev \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-install -j$(nproc) mysqli \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl \
	&& pecl install memcached-3.2.0 \
	&& docker-php-ext-enable memcached \
    && pecl install memcache-8.0 \
    && docker-php-ext-enable memcache

FROM base as builder 

# Use the default production configuration (this fixes https://github.com/osTicket/osTicket/issues/6574)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && rm "$PHP_INI_DIR/php.ini-development"

RUN git clone --depth 1 -b v1.18 https://github.com/osTicket/osTicket.git /install 
RUN cd /install && php manage.php deploy --setup /var/www/html \
    && php manage.php deploy -v /var/www/html \
    && mkdir /var/www/html/include/container_config \
    && cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/container_config/ost-config.php \
    && chmod 0666 /var/www/html/include/container_config/ost-config.php \
    && ln -s /var/www/html/include/container_config/ost-config.php /var/www/html/include/ost-config.php \
    && rm -rf /install

# Install plugins
RUN cd /tmp \
    && git clone https://github.com/osTicket/osTicket-plugins.git plugins \
    && cd ./plugins && php make.php hydrate \
    && for plugin in audit auth-* storage-s3; do \
          php -dphar.readonly=0 make.php build $plugin; \
          cp ${plugin}.phar /var/www/html/include/plugins; \
        done

FROM base 

# Use the default production configuration 
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && rm "$PHP_INI_DIR/php.ini-development"

COPY --from=builder /var/www/html /var/www/html 
