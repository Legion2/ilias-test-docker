#!/bin/sh

/etc/init.d/mysql start

if [ ! -e /data/init ]; then
    dockerize -template /data/ilias.ini.php.template:/var/www/html/ilias/ilias.ini.php
    dockerize -template /data/client.ini.php.template:/var/www/html/ilias/data/myilias/client.ini.php
    sed -i "s|insertsessionexpiredate|$(date -d "+1 week" +%s)|g" /data/iliascleandb.sql
    sed -i "s|\\\$GLOBALS\['DIC'\]\['ilAuthSession'\]->setUserId(\\\$_SESSION\[\"AccountId\"\])|\$GLOBALS['DIC']['ilAuthSession'];\$_SESSION[\"AccountId\"] = 274;\$GLOBALS['DIC']['ilAuthSession']->setUserId(\$_SESSION[\"AccountId\"])|g" /var/www/html/ilias/Services/PHPUnit/classes/class.ilUnitUtil.php

    chmod 666 /var/www/html/ilias/ilias.ini.php
    chmod 666 /var/www/html/ilias/data/myilias/client.ini.php

    mysql < /docker-entrypoint-initdb.d/ilias-user.sql
    mysql ilias < /data/iliascleandb.sql

    touch /data/init
fi

if [ -z "$1" ]; then
    apache2 -D FOREGROUND
else
    /etc/init.d/apache2 start
    /bin/sh -c "$@"
fi