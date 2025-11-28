FROM docker.io/debian:stable-slim

ENV TLS_CERY_FILE /ssl/sample.com.cer
ENV TLS_KEY_FILE /ssl/sample.com.key
#only support mysql now
ENV DB_TYPE mysql
ENV DB_USER admin
ENV DB_PASSWORD 123456
ENV DB_PORT 3306
ENV DB_HOST 127.0.0.1
ENV DB_DBNAME vmail

RUN apt update && apt -y install dovecot-core dovecot-pop3d dovecot-imapd dovecot-lmtpd dovecot-mysql && apt clean && groupadd -g 5000 vmail && useradd -g vmail -u 5000 vmail -d /mail/ && groupadd -g 200 postfix && useradd -g postfix -u 200 postfix -d /mail/

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["dovecot", "-F"]
