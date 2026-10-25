FROM docker.io/alpine:latest

ENV USE_TLS=0
ENV TLS_CERT_FILE=/ssl/sample.com.cer
ENV TLS_KEY_FILE=/ssl/sample.com.key
#only support mysql now
ENV DB_TYPE=mysql
ENV DB_USER=admin
ENV DB_PASSWORD=123456
ENV DB_PORT=3306
ENV DB_HOST=127.0.0.1
ENV DB_DBNAME=vmail
ENV USE_HAPROXY=0
ENV TRUSTED_PROXY_NETWORKS="127.0.0.1/8 ::1/128"

RUN apk add --no-cache dovecot dovecot-pop3d dovecot-lmtpd dovecot-mysql tzdata && addgroup -g 5000 vmail && adduser -G vmail -u 5000 -h /mail/ -H -S vmail && addgroup -g 200 postfix && adduser -G postfix -u 200 -h /mail/ -H -S postfix

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["dovecot", "-F"]
