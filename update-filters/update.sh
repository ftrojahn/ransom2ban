#!/bin/bash

BASEDIR=$(dirname "$0")
HONEYPOT_FILES_RE=$(cat /etc/fail2ban/filter.d/ransom2ban-filter.conf | grep 'honeypot_files_re=' | cut -d '(' -f 2 | head -c-2)

if curl --output /dev/null --silent --head --fail https://fsrm.experiant.ca/api/v1/combined; then
	cp -a $BASEDIR/fsrm/fsrm.json $BASEDIR/old/fsrm.json_`date +%Y%m%d_%H%M`.bak
	curl -o $BASEDIR/fsrm/fsrm.json https://fsrm.experiant.ca/api/v1/combined
	cp -a $BASEDIR/fsrm/fsrm.lst $BASEDIR/old/fsrm.lst_`date +%Y%m%d_%H%M`.bak
	jq -r .filters[] $BASEDIR/fsrm/fsrm.json > $BASEDIR/fsrm/fsrm.lst
	sed -i 's/\./\\./g; s/\[/\\[/g; s/\]/\\]/g; s/\@/\\@/g; s/\$/\\$/g; s/\ /\\ /g; s/\!/\\!/g;' $BASEDIR/fsrm/fsrm.lst
	sed -i 's/\#/\\#/g; s/\+/\\+/g; s/\-/\\-/g; s/\;/\\;/g; s/\,/\\,/g; s/\~/\\~/g; s/'\''/\\'\''/g; s/^\*//g' $BASEDIR/fsrm/fsrm.lst
	cp -a /etc/fail2ban/filter.d/ransom2ban-filter.conf $BASEDIR/old/ransom2ban-filter.conf_`date +%Y%m%d_%H%M`.bak
	cat > /etc/fail2ban/filter.d/ransom2ban-filter.conf <<EOF
[Definition]
__honeypot_files_re=(${HONEYPOT_FILES_RE})
__known_ransom_files_re=(`sed ':a;N;$!ba;s/\n/$|/g' $BASEDIR/fsrm/fsrm.lst`$)
#failregex=^ $(hostname -s) smbd_audit: IP=<HOST>\|.*%(__honeypot_files_re)s
#          ^ $(hostname -s) smbd_audit: IP=<HOST>\|.*%(__known_ransom_files_re)s
failregex=smbd_audit: IP=<HOST>\|.*%(__honeypot_files_re)s
          smbd_audit: IP=<HOST>\|.*%(__known_ransom_files_re)s
EOF
	systemctl restart fail2ban
fi

