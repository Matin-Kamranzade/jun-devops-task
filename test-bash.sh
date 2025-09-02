#!/bin/bash

LOGFILE="/var/log/test_mon.log"
PIDFILE="/var/run/test_mon.pid"
PROCESS="test"
MON_SERV="https://test.com/monitoring/test/api"
CURRENT_PID=`pgrep -x "$PROCESS" | head -n 1`

if test -z "$CURRENT_PID" ; then
    exit 0
fi

if test -f "$PIDFILE" ; then
    OLD_PID=`cat "$PIDFILE"`
    if test "$CURRENT_PID" != "$OLD_PID" ; then
        echo "`date` - $PROCESS был перезагружен (старый пид=$OLD_PID, новый пид=$CURRENT_PID)" >> $LOGFILE
    fi
fi
echo "$CURRENT_PID" > "$PIDFILE"

if ! curl -s --fail $MON_SERV > /dev/null; then
    echo "`date` - Сервер мониторинга недоступен" >> $LOGFILE
fi

sleep 60
exec $0
