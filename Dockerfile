FROM alpine/git AS ilias

RUN set -eux; \
    cd /; \
    git clone https://github.com/ILIAS-eLearning/ILIAS.git ilias; \
    cd ilias; \
    git checkout release_5-2

FROM scratch AS source

COPY --from=ilias /ilias /var/www/html/ilias

COPY templates/000-default.conf.template /etc/apache2/sites-enabled/000-default.conf

COPY templates/php.ini.template /usr/local/etc/php/conf.d/php.ini

COPY templates/ilias-user.sql /docker-entrypoint-initdb.d/

COPY templates/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

COPY templates/ilias.ini.php.template /data/
COPY templates/client.ini.php.template /data/
COPY templates/iliascleandb.sql /data/

FROM ubuntu:16.04

RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV MYSQL_ROOT_PASSWORD password

# Apache ENVs
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_SERVER_NAME localhost

RUN set -eux; \
    { \
		echo "mariadb-server" mysql-server/root_password password $MYSQL_ROOT_PASSWORD; \
		echo "mariadb-server" mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD; \
	} | debconf-set-selections; \
    apt-get update; \
    apt-get install -y \
        apache2 \
        imagemagick \
        libapache2-mod-php7.0 \
        mariadb-server \
        openjdk-8-jdk \
        php7.0 \
        php7.0-gd \
        php7.0-mysql \
        php7.0-mbstring \
        php-xml \ 
        unzip \
        wget \
        zip \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=source --chown=www-data:www-data /var/www/html/ilias /var/www/html/ilias

COPY --from=source /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf

COPY --from=source /usr/local/etc/php/conf.d/php.ini /usr/local/etc/php/conf.d/php.ini

COPY --from=source /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

COPY --from=source /usr/local/bin/docker-entrypoint.sh /usr/local/bin/

EXPOSE 80

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENTRYPOINT [ "docker-entrypoint.sh" ]

# ilias setup

COPY --from=source /data /data

ENV TZ Europe/Berlin
ENV ILIAS_MASTER_PASSWORD password
ENV ILIAS_MAIL ilias@example.com

RUN set -eux; \
    mkdir -p /var/www/html/ilias/data/myilias/css; \
    mkdir -p /var/www/html/ilias/data/myilias/lm_data; \
    mkdir -p /var/www/html/ilias/data/myilias/mobs; \
    mkdir -p /var/www/html/ilias/data/myilias/usr_images; \
    chown -R www-data:www-data  /var/www/html/ilias/data/myilias; \
    chmod -R 775 /var/www/html/ilias/data; \
    chmod 666 /data/ilias.ini.php.template; \
    chmod 666 /data/client.ini.php.template; \
    mkdir -p /opt/iliasdata/myilias/files; \
    mkdir -p /opt/iliasdata/myilias/forum; \
    mkdir -p /opt/iliasdata/myilias/lm_data; \
    mkdir -p /opt/iliasdata/myilias/mail; \
    chown -R www-data:www-data /opt/iliasdata; \
    chmod -R 751 /opt/iliasdata

VOLUME  /var/www/html/ilias/Customizing