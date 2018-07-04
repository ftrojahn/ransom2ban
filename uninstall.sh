#!/bin/bash

BASEDIR=$(dirname "$0")

rm -f /etc/fail2ban/jail.d/ransom2ban-jail.conf 
rm -f /etc/fail2ban/filter.d/ransom2ban-filter.conf
rm -f /etc/fail2ban/action.d/ransom2ban-mail.conf
systemctl stop fail2ban
systemctl disable fail2ban
 
rm -f /etc/rsyslog.d/00-samba_audit.conf
systemctl restart rsyslogd

rm -f /etc/logrotate.d/ransom2ban

rm -dfr /var/log/ransom2ban

echo "Remember to disable full audit on samba and delete all honeypot folders created on shares"
