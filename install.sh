#!/bin/bash

BASEDIR=$(dirname "$0")

cp $BASEDIR/fail2ban-config/jail.d/ransom2ban-jail.conf /etc/fail2ban/jail.d/
cp $BASEDIR/fail2ban-config/filter.d/ransom2ban-filter.conf /etc/fail2ban/filter.d/
cp $BASEDIR/fail2ban-config/action.d/ransom2ban-mail.conf /etc/fail2ban/action.d/

cp $BASEDIR/rsyslog-config/00-samba_audit.conf /etc/rsyslog.d/

mkdir /var/log/ransom2ban
mkdir /var/log/ransom2ban/old
touch /var/log/ransom2ban/samba_audit.log
cp $BASEDIR/logrotate-config/ransom2ban /etc/logrotate.d/

systemctl restart rsyslog
systemctl enable fail2ban
systemctl restart fail2ban

