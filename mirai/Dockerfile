From 0kami/botnets:base

MAINTAINER wh1t3P1g <https://github.com/0kami>

COPY source /root/source
COPY wait-for-it.sh /root


WORKDIR /root

RUN chmod a+x wait-for-it.sh

CMD ["/bin/sh", "-c", "/root/wait-for-it.sh"]
