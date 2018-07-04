# Ransom2Ban

Scripts to configure a Linux fileserver to protect Samba sharing files from encryption performed by ransomware on PCs.

This project was born from the merger and customization (and localization in italian) of three projects hosted by GitHub.

The first and principal is <a href="https://github.com/CanaryTek/ransomware-samba-tools">Ransomware samba tools</a> by **CanaryTek**, from which it was forked, the second is <a href="https://github.com/quickreflex/ransomware-samba-ban">Ransomware Samba Ban</a> by **quickreflex**, from which it takes the method to keep filters updated. Finally a special thanks to <a href="https://github.com/nexxai/CryptoBlocker">CryptoBlocker</a> by **nexxai** which maintains a public list of known ransomware encrypted extensions and filenames (<a href="https://fsrm.experiant.ca" target="_blank">https://fsrm.experiant.ca</a>).

**How it works**: it enable full audit in Samba and monitor the logs with fail2ban. When it detect a create/delete/rename log of file with known ransomware extension or name, otherwise of a honeypot file (in dedicated folders created on samba shares, each with 2K bait files), it bans the client IP and send a notification mail to administrator with details and instructions for unban.

**Prerequisites**: fail2ban, curl, jq, pyinotify (yum install epel-release; yum update; yum install fail2ban curl jq python-inotify)

Tested on Linux CentOS/RHEL 7

**Installation**: 

./install.sh

To enable samba audit: edit /etc/samba/smb.conf as described in samba-config/add-to-smb.conf; systemctl restart smb

To config mail notifications: edit sender, smtp and dest in /etc/fail2ban/jail.d/ransom2ban-jail.conf; systemctl restart fail2ban

To create honeypot folder ---ANTIVIRUS_BAIT_DO_NOT_DELETE---: honeypots-create/create.sh /path/to/share (no arg=all)

To update filter of known ransomware encrypted extensions and file names from fsrm.experiant.ca: update-filters/update.sh

To schedule filter update (not recommended due to the remote risk of false positives for new extensions): add in root crontab 

0 0 * * * /path/to/ransom2ban/update-filters/update.sh > /var/log/ransom2ban/update.log 2>&1

**Files**:

/etc/fail2ban/jail.d/ransom2ban-jail.conf

/etc/fail2ban/filter.d/ransom2ban-filter.conf

/etc/fail2ban/action.d/ransom2ban-mail.conf

/etc/rsyslog.d/00-samba_audit.conf

/var/log/ransom2ban/samba_audit.log

/etc/logrotate.d/ransom2ban

/var/log/ransom2ban/old/...

/path/to/shares/---ANTIVIRUS_BAIT_DO_NOT_DELETE---/...

**DISCLAIMER**: this project is provided as is. I can not be held liable if this does not thwart a ransomware infection, causes your server to spontaneously combust, results in job loss, etc.

### README project Ransomware samba tools:

https://github.com/CanaryTek/ransomware-samba-tools

Tools to help stop ransomware infections in a samba fileserver.

Basically, what it does is enable full audit in Samba server and monitor the logs with fail2ban. When it detect a "suspicious" change, it bans the client IP.

DISCLAIMER: What we do with this tools is not new, these technics have been used in windows server for a long time. Even the idea of using samba audit is not ours, we first saw it in a german magazine (https://www.heise.de/security/artikel/Erpressungs-Trojaner-wie-Locky-aussperren-3120956.html)
 
Right now we have two types of detections:

  * Known ransomware: we monitor the logs for known ransomware extensions and filenames. The drawback of this approach is that it only detects known ransomware
  * Honeypots: we setup a honeypot on every shared folder with names such that an enumeration from a windows client will try to infect that folder first. And we monitor files in that honeypot folder

[<a href="https://github.com/CanaryTek/ransomware-samba-tools/blob/master/README.md">...</a>]

### README project Ransomware Samba Ban:

https://github.com/quickreflex/ransomware-samba-ban

This is bash script to detect ransomware activity and ban infected IP address to protect us from files encryption at samba server.

Basically, what it does is enable full audit in Samba server and monitor the logs for known ransomware extensions and file names. When detect a ransomware activity, it ban infected IP address to protect us from files encryption at samba server.

[<a href="https://github.com/quickreflex/ransomware-samba-ban/blob/master/README.md">...</a>]

### README project CryptoBlocker:

https://github.com/nexxai/CryptoBlocker

This is a solution to block users infected with different ransomware variants.

[<a href="https://github.com/nexxai/CryptoBlocker/blob/master/README.md">...</a>]
