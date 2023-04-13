FROM docker.io/ubuntu:22.04

RUN apt update -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y git apache2  php8.1 php8.1-mysql php-pear \
        php8.1-gd php8.1-imap php8.1-mbstring php8.1-intl php8.1-apcu curl mysql-client git \
    && rm /var/www/html/index.html 

# Need kubectl to support the installer on Kubernetes.
RUN curl https://dl.k8s.io/release/v1.26.3/bin/linux/amd64/kubectl --output /usr/bin/kubectl \
    && chmod 0555 /usr/bin/kubectl 

RUN git clone -b v1.17.3 https://github.com/osTicket/osTicket.git install 
RUN cd /install && php manage.php deploy --setup /var/www/html \
    && php manage.php deploy -v /var/www/html \
    && mkdir /var/www/html/include/container_config \
    && cp /var/www/html/include/ost-sampleconfig.php /var/www/html/include/container_config/ost-config.php \
    && chmod 0666 /var/www/html/include/container_config/ost-config.php \
    && ln -s /var/www/html/include/container_config/ost-config.php /var/www/html/include/ost-config.php \
    && rm -rf /install 

CMD /usr/sbin/apachectl -D FOREGROUND
