FROM docker.io/alpine:latest

ENV TLS_CERY_FILE=/ssl/sample.com.cer
ENV TLS_KEY_FILE=/ssl/sample.com.key
ENV MAIL_DOMAIN=sample.com
#only support mysql now
ENV DB_TYPE=mysql
ENV DB_USER=admin
ENV DB_PASSWORD=123456
ENV DB_PORT=3306
ENV DB_HOST=127.0.0.1
ENV DB_DBNAME=vmail


RUN addgroup -g 200 postfix && adduser -G postfix -u 200 -h /var/spool/postfix -H -S postfix && apk update && apk add --no-cache postfix postfix-mysql tzdata && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postfix", "start-fg"]
