#!/bin/bash
if [[ -z "$1" ]]; then
	echo "Please specify target." >&2
	exit 1
fi

EMAIL_TO=dbralir@gmail.com
MY_DIR=`pwd`
TARGET=$1
BUILD_DIR=$MY_DIR/$TARGET
BUILD_CMD=./build.sh
BUILD_LOG=$MY_DIR/$TARGET.log.`date '+%Y%m%d%H%M'`

echo "Build started at `date`." >$BUILD_LOG
cd $BUILD_DIR
$BUILD_CMD >>$BUILD_LOG 2>&1
echo "Build finished at `date`." >>$BUILD_LOG

# echo "Build log for $TARGET attached." | mutt -a "$BUILD_LOG" -s "Build Log: $TARGET" $EMAIL_TO

