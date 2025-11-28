#!/bin/sh

init() {
    if [ -f /.installed ]; then
        return 0
    fi

    touch /.installed

    mkdir -p /etc/dovecot/conf.d

    local VERSION="$(dovecot --version | cut -d - -f 1)"

    cat >/etc/dovecot/dovecot.conf <<EOF
dovecot_config_version = $VERSION
dovecot_storage_version = $VERSION
!include conf.d/*.conf
EOF

    cat >/etc/dovecot/conf.d/10-protocols.conf <<EOF
protocols {
  imap = yes
  lmtp = yes
  pop3 = yes
}
EOF
    cat >/etc/dovecot/conf.d/10-auth.conf <<EOF
!include auth-sql.conf.ext
EOF

    cat >/etc/dovecot/conf.d/auth-sql.conf.ext <<EOF
sql_driver = mysql
mysql $DB_HOST {
  user = $DB_USER
  password = $DB_PASSWORD
  dbname = $DB_DBNAME
  port = $DB_PORT
}
passdb sql {
  default_password_scheme = SHA256
  query = SELECT email as user, password FROM virtual_email_v WHERE user = '%{user|username}' AND domain = '%{user|domain}'
}
userdb sql {
  query = SELECT '/mail/home/%{user|username}' as home, 5000 as uid, 5000 as gid FROM virtual_email_v WHERE user = '%{user|username}'
}
EOF

    cat >/etc/dovecot/conf.d/10-mail.conf <<EOF
mail_privileged_group = vmail
mail_driver = maildir
mail_path = /mail/vmail/%{user|username}
mail_inbox_path = /mail/vmail/%{user|username}/.INBOX

namespace inbox {
  inbox = yes
}

EOF

    cat >/etc/dovecot/conf.d/10-master.conf <<EOF
service imap-login {
  inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    port = 993
    ssl = yes
  }
}

service pop3-login {
  inet_listener pop3 {
    port = 110
  }
  inet_listener pop3s {
    port = 995
    ssl = yes
  }
}

service lmtp {
  unix_listener /socket/dovecot-lmtp {
    mode = 0660
    user = postfix
    group = postfix
  }
}

service auth {
  unix_listener /socket/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
  unix_listener auth-userdb {
    mode = 0660
    user = vmail
    group = vmail
  }
}

service auth-worker {
  user = vmail
}
EOF

  cat >/etc/dovecot/conf.d/10-ssl.conf <<EOF
ssl = yes
ssl_server_cert_file = $TLS_CERY_FILE
ssl_server_key_file = $TLS_KEY_FILE
ssl_min_protocol = TLSv1.2
EOF

  cat >/etc/dovecot/conf.d/10-logging.conf <<EOF
log_path = /dev/stdout
info_log_path = /dev/stdout
debug_log_path = /dev/stderr
EOF
}

if [ "$1" = 'dovecot' ]; then
    find /mail \! -user vmail -exec chown vmail:vmail '{}' +
    init
fi

exec "$@"
