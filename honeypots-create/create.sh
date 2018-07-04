#!/bin/bash
# Setup samba honeypots to detect ransomware activity
# Kuko Armas <kuko@canarytek.com>
# Forked by Roblio 

BASEDIR=$(dirname "$0")

bait_template_dir="$BASEDIR/honeypot-files"
bait_files_dir="---ANTIVIRUS_BAIT_DO_NOT_DELETE---"
bait_files_name="ANTIVIRUS_BAIT_DO_NOT_DELETE-"

if [ "x$1" == "x" ]; then
	shares=`testparm -s 2>/dev/null | grep path | awk '{ print $3}'`
else
	shares="$1"
fi

for share in $shares; do
	echo "Setting honeypot in ${share}"
	mkdir -p "/${share}/${bait_files_dir}"
	for fullfile in ${bait_template_dir}/*; do
		filename=$(basename "${fullfile}")
		extension="${filename##*.}"
 		for i in {1..100} ; do
			randname="$(tr -dc '[:alnum:]' </dev/urandom | head -c 8)"
			cp "$fullfile" "/$share/$bait_files_dir/${bait_files_name}${randname}.${extension}"
 		done
	done
	chmod -R 777 "/$share/${bait_files_dir}"
	touch -c -t 197103160001 "/$share/${bait_files_dir}"
    touch -c -t 197103160001 "/$share/${bait_files_dir}/"*
done
