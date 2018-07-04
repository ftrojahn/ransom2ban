#!/bin/bash
# Setup samba honeypots to detect ransomware activity
# Kuko Armas <kuko@canarytek.com>
# Forked by Roblio 

BASEDIR=$(dirname "$0")

bait_files_dir="---ANTIVIRUS_ICT_NON_CANCELLARE---"

if [ "x$1" == "x" ]; then
	shares=`testparm -s 2>/dev/null | grep path | awk '{ print $3}'`
else
	shares="$1"
fi

for share in $shares; do
	echo "Deleting honeypot in ${share}"
	rm -drf "/${share}/${bait_files_dir}"
done
