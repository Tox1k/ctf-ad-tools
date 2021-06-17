#!/bin/bash

if (( $# != 1 )); then
	>&2 echo "Illegal number of parameters"
	exit
fi


CAPID=1

CARONTE_HOSTNAME=$1

while true
do
	CAPID=$(expr $CAPID + 1);
	FNAME="cap$CAPID.pcap";
	tcpdump -eni any -vv -w $FNAME &
	sleep 120;
	pkill tcpdump;
	curl -X POST "http://${CARONTE_HOSTNAME}:3333/api/pcap/upload" \
		-H "Content-Type: multipart/form-data" \
		-F "file=@$FNAME" \
		-F "flush_all=false";
	done
