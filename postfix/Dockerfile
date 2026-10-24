FROM docker.io/alpine:latest

ENV USE_TLS=0
ENV TLS_CERT_FILE=/ssl/sample.com.cer
ENV TLS_KEY_FILE=/ssl/sample.com.key
ENV MAIL_DOMAIN=sample.com
#only support mysql now
ENV DB_TYPE=mysql
ENV DB_USER=admin
ENV DB_PASSWORD=123456
ENV DB_PORT=3306
ENV DB_HOST=127.0.0.1
ENV DB_DBNAME=vmail
ENV USE_RELAY=0
ENV RELAYHOST=
ENV SMTP_USER=
ENV SMTP_PASSWORD=
ENV USE_HAPROXY=0
ENV TRUSTED_PROXY_NETWORKS=127.0.0.1/8 ::1/128

RUN addgroup -g 200 postfix && adduser -G postfix -u 200 -h /var/spool/postfix -H -S postfix &&  apk add --no-cache postfix postfix-mysql tzdata

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postfix", "start-fg"]
