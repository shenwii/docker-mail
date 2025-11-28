#!/bin/sh

init() {
    if [ -f /.installed ]; then
        return 0
    fi

    touch /.installed

    postalias /etc/postfix/aliases

    #maybe it's is a bug
    DB_HOST=$(nslookup -type=A $DB_HOST | grep 'Address:' | tail -n 1 | awk '{ print $2 }')

    cat >/etc/postfix/main.cf <<EOF
compatibility_level = 3.10
smtpd_banner = \$myhostname ESMTP \$mail_name (Alpine)
biff = no
myhostname = $MAIL_DOMAIN
myorigin = \$myhostname
mydestination = localhost
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
maillog_file = /dev/stdout
inet_protocols = all
inet_interfaces = all

local_transport = lmtp:unix:dovecot/dovecot-lmtp
virtual_transport = lmtp:unix:dovecot/dovecot-lmtp
mailbox_transport = lmtp:unix:dovecot/dovecot-lmtp
lmtp_host_lookup = native

smtpd_tls_key_file = $TLS_KEY_FILE
smtpd_tls_cert_file = $TLS_CERY_FILE
smtpd_tls_security_level = may

smtpd_sasl_type = dovecot
smtpd_sasl_path = dovecot/auth
smtpd_sasl_auth_enable = yes
smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination

virtual_mailbox_domains = mysql:/etc/postfix/db-virtual-mailbox-domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/db-virtual-mailbox-maps.cf
virtual_alias_maps = mysql:/etc/postfix/db-virtual-alias-maps.cf
virtual_alias_domains = mysql:/etc/postfix/db-virtual-alias-domains.cf
EOF

    cat >/etc/postfix/db-virtual-mailbox-domains.cf <<EOF
user = $DB_USER
password = $DB_PASSWORD
hosts = $DB_HOST:$DB_PORT
dbname = $DB_DBNAME

query = SELECT 1 FROM virtual_domains WHERE domain='%s'
EOF

    cat >/etc/postfix/db-virtual-mailbox-maps.cf <<EOF
user = $DB_USER
password = $DB_PASSWORD
hosts = $DB_HOST:$DB_PORT
dbname = $DB_DBNAME

query = SELECT 1 FROM virtual_email_v WHERE email='%s'
EOF

    cat >/etc/postfix/db-virtual-alias-maps.cf <<EOF
user = $DB_USER
password = $DB_PASSWORD
hosts = $DB_HOST:$DB_PORT
dbname = $DB_DBNAME

query = SELECT destination FROM virtual_alias_maps WHERE source='%s'
EOF

    cat >/etc/postfix/db-virtual-alias-domains.cf <<EOF
user = $DB_USER
password = $DB_PASSWORD
hosts = $DB_HOST:$DB_PORT
dbname = $DB_DBNAME

query = SELECT target_domain FROM virtual_alias_domain WHERE alias_domain='%d'
EOF

    cat >/etc/postfix/master.cf <<'EOF'
postlog   unix-dgram n  -       n       -       1       postlogd
smtp      inet  n       -       y       -       -       smtpd
submission inet n       -       y       -       -       smtpd
 -o smtpd_tls_security_level=encrypt
submissions     inet  n       -       y       -       -       smtpd
  -o smtpd_tls_wrappermode=yes
pickup    unix  n       -       y       60      1       pickup
cleanup   unix  n       -       y       -       0       cleanup
qmgr      unix  n       -       n       300     1       qmgr
tlsmgr    unix  -       -       y       1000?   1       tlsmgr
bounce    unix  -       -       y       -       0       bounce
defer     unix  -       -       y       -       0       bounce
trace     unix  -       -       y       -       0       bounce
verify    unix  -       -       y       -       1       verify
flush     unix  n       -       y       1000?   0       flush
proxymap  unix  -       -       n       -       -       proxymap
proxywrite unix -       -       n       -       1       proxymap
smtp      unix  -       -       y       -       -       smtp
relay     unix  -       -       y       -       -       smtp
        -o syslog_name=${multi_instance_name?{$multi_instance_name}:{postfix}}/$service_name

rewrite   unix  -       -       y       -       -       trivial-rewrite
showq     unix  n       -       y       -       -       showq
error     unix  -       -       y       -       -       error
retry     unix  -       -       y       -       -       error
discard   unix  -       -       y       -       -       discard
local     unix  -       n       n       -       -       local
virtual   unix  -       n       n       -       -       virtual
lmtp      unix  -       -       y       -       -       lmtp
anvil     unix  -       -       y       -       1       anvil
scache    unix  -       -       y       -       1       scache
EOF
}

if [ "$1" = 'postfix' ]; then
    init
fi

exec "$@"
