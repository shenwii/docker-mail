FROM docker.io/debian:stable-slim

ENV TLS_CERY_FILE /ssl/sample.com.cer
ENV TLS_KEY_FILE /ssl/sample.com.key
ENV MAIL_DOMAIN sample.com
#only support mysql now
ENV DB_TYPE mysql
ENV DB_USER admin
ENV DB_PASSWORD 123456
ENV DB_PORT 3306
ENV DB_HOST 127.0.0.1
ENV DB_DBNAME vmail


RUN groupadd -g 200 postfix && useradd -g postfix -u 200 postfix -d /var/spool/postfix && apt update && apt -y install postfix postfix-mysql && apt clean

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postfix", "start-fg"]
