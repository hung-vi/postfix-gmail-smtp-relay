#!/bin/bash

# Set up host name
if [ ! -z "$HOSTNAME" ]; then
	postconf -e myhostname=$HOSTNAME
else
	postconf -e myhostname=$(hostname)
fi
postfix stop
service postfix start

echo "- Staring rsyslog and postfix"
exec supervisord -c /etc/supervisord.conf
