#!/bin/bash
set -euo pipefail

# Copy current DNS config etc. into postfix chroot
FILES="localtime services resolv.conf hosts nsswitch.conf"
for file in $FILES; do
  cp /etc/${file} /var/spool/postfix/etc/${file}
  chmod a+rX /var/spool/postfix/etc/${file}
done

if [[ -f /etc/mailhostname ]]; then
  MYHOSTNAME="$(cat /etc/mailhostname)"

  if [[ -n "${MYDOMAIN:-}" ]]; then
    if [[ "$MYHOSTNAME" =~ [.] ]]; then
      postconf mydomain="$MYDOMAIN"
    else
      MYHOSTNAME="$MYHOSTNAME.$MYDOMAIN"
    fi
  fi
fi

postconf myhostname="$MYHOSTNAME" mynetworks="172.17.42.1 $MYNETWORKS"


# Redirect syslog to stdout if USE_SYSLOG is not set
if [[ -z "${USE_SYSLOG:-}" ]]; then
  /usr/local/bin/syslog-stdout.py &
fi

exec /usr/lib/postfix/sbin/master -d
