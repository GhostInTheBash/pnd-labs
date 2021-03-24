#!/bin/bash

ARGS=$@
SELF=$0
DIBBLER_ACTION=$1

function log () {
	logger $SELF $@
}

log ARG: $ARGS
log ENV: `env`

LOG=/var/log/dibbler/client.sh-log

set >> $LOG

FLAG=1
IFACE=''
PREFIX=''
for i in $DOWNLINK_PREFIXES
do
	echo IFACE_NAME: $IFACE_NAME >> $LOG
	if [[ $FLAG = 1 ]]
	then
		IFACE=$i
	else
		PREFIX=$i
		PREFIX_ADD=`echo $PREFIX | cut -d/ -f1`
		PREFIX_LEN=`echo $PREFIX | cut -d/ -f2`

		log IFACE:$IFACE PREFIX:$PREFIX PREFIX_ADD:$PREFIX_ADD PREFIX_LEN:$PREFIX_LE
		log `ip address show dev $IFACE`

		# Flash global ipv6 addresse from iface
		ip -6 addr flush dev $IFACE scope global

		if [ "$DIBBLER_ACTION" == "add" -o "$DIBBLER_ACTION" == "update" ]; then
			# set the first IP from the prefix
			CMD="ip address add ${PREFIX_ADD}1/$PREFIX_LEN dev $IFACE"
			log $CMD
			$CMD
		fi
	fi
	let FLAG=3-$FLAG
done
