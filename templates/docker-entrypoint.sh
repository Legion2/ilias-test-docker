#!/bin/bash

/etc/init.d/mysql start

md5passwd=$(echo -n $ILIAS_MASTER_PASSWORD | md5sum | cut -f1 -d' ')
md5passwd="5f4dcc3b5aa765d61d8327deb882cf99"

dockerize -template /data/ilias.ini.php.template:/var/www/html/ilias/ilias.ini.php
dockerize -template /data/client.ini.php.template:/var/www/html/ilias/data/myilias/client.ini.php

mysql < /docker-entrypoint-initdb.d/ilias-user.sql
mysql ilias < /data/iliascleandb.sql

apache2 -D FOREGROUND