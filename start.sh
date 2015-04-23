#!/bin/bash
set -e

postconf myhostname=$MYHOSTNAME mynetworks="172.17.42.1 $MYNETWORKS"

/usr/local/bin/syslog-stdout.py &
exec /usr/lib/postfix/master -d
