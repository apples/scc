#!/bin/bash

set -e

ISCB_LOGIN="root@10.0.0.11"
ISCB_COMMAND="iscb psu | grep -i power"

SLEEP_TIME=2
OUTPUT_FILES=()

function getpower {
	ssh "$ISCB_LOGIN" "$ISCB_COMMAND"
}

while [ $# -gt 0 ]
do
	case "$1" in
	-s)
		shift
		SLEEP_TIME=$1
		;;
	*)
		OUTPUT_FILES[${#OUTPUT_FILES[@]}]="$1"
		;;
	esac
	shift
done

if [ ! -z "$DEBUG" ]
then
	echo "DEBUG: ISCB_LOGIN=\"$ISCB_LOGIN\"" 1>&2
	echo "DEBUG: ISCB_COMMAND=\"$ISCB_COMMAND\"" 1>&2
	echo "DEBUG: SLEEP_TIME=\"$SLEEP_TIME\"" 1>&2
	echo "DEBUG: OUTPUT_FILES=\"${OUTPUT_FILES[@]}\"" 1>&2
fi

while [ 1 ]
do
	getpower | tee -a "${OUTPUT_FILES[@]}"
	sleep $SLEEP_TIME
done

