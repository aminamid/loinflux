#! /usr/bin/env bash

### BEGIN INIT INFO
# Provides:          influxd
# Required-Start:    $all
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start influxd at boot time
### END INIT INFO

# this init script supports three different variations:
#  1. New lsb that define start-stop-daemon
#  2. Old lsb that don't have start-stop-daemon but define, log, pidofproc and killproc
#  3. Centos installations without lsb-core installed
#
# In the third case we have to define our own functions which are very dumb
# and expect the args to be positioned correctly.

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}

BASEDIR=$(abs_dirname "$0")
export BASEPORT=10000
${BASEDIR}/lib/init.py
if [ ! -d ${BASEDIR}/log ]; then
    mkdir -p ${BASEDIR}/log
fi
if [ ! -d ${BASEDIR}/tmp ]; then
    mkdir -p ${BASEDIR}/tmp
fi
if [ ! -d ${BASEDIR}/data/tmp ]; then
    mkdir -p ${BASEDIR}/data/tmp
fi
if [ ! -d ${BASEDIR}/data/db  ]; then
    mkdir -p ${BASEDIR}/data/db
fi
if [ ! -d ${BASEDIR}/data/raft  ]; then
    mkdir -p ${BASEDIR}/data/raft
fi
if [ ! -d ${BASEDIR}/data/wal  ]; then
    mkdir -p ${BASEDIR}/data/wal
fi

if [ -r /lib/lsb/init-functions ]; then
    source /lib/lsb/init-functions
fi

DEFAULT=${BASEDIR}/default/influxdb

if [ -r $DEFAULT ]; then
    source $DEFAULT
fi

if [ -z "$STDOUT" ]; then
    STDOUT=$BASEDIR/log/influxd.log
fi
if [ ! -f "$STDOUT" ]; then
    mkdir -p `dirname $STDOUT`
fi

if [ -z "$STDERR" ]; then
    STDERR=${BASEDIR}/log/influxd.err
fi
if [ ! -f "$STDERR" ]; then
    mkdir -p `dirname $STDERR`
fi


OPEN_FILE_LIMIT=65536

function pidofproc() {
    if [ $# -ne 3 ]; then
        echo "Expected three arguments, e.g. $0 -p pidfile daemon-name"
    fi

    pid=`pgrep -f $3`
    local pidfile=`cat $2`

    if [ "x$pidfile" == "x" ]; then
        return 1
    fi

    if [ "x$pid" != "x" -a "$pidfile" == "$pid" ]; then
        return 0
    fi

    return 1
}

function killproc() {
    if [ $# -ne 3 ]; then
        echo "Expected three arguments, e.g. $0 -p pidfile signal"
    fi

    pid=`cat $2`

    kill -s $3 $pid
}

function log_failure_msg() {
    echo "$@" "[ FAILED ]"
}

function log_success_msg() {
    echo "$@" "[ OK ]"
}

# Process name ( For display )
name=influxd

# Daemon name, where is the actual executable
daemon=${BASEDIR}/lib/influxd

# pid file for the daemon
pidfile=${BASEDIR}/tmp/influxd.pid

# Configuration file
config=${BASEDIR}/tmp.influxdb.conf

# If the daemon is not there, then exit.
[ -x $daemon ] || exit 5

case $1 in
    start)
        # Checked the PID file exists and check the actual status of process
        if [ -e $pidfile ]; then
            pidofproc -p $pidfile $daemon > /dev/null 2>&1 && status="0" || status="$?"
            # If the status is SUCCESS then don't need to start again.
            if [ "x$status" = "x0" ]; then
                log_failure_msg "$name process is running"
                exit 1 # Exit
            fi
        fi

        # Bump the file limits, before launching the daemon. These will carry over to
        # launched processes.
        ulimit -n $OPEN_FILE_LIMIT
        if [ $? -ne 0 ]; then
            log_failure_msg "set open file limit to $OPEN_FILE_LIMIT"
        fi

        log_success_msg "Starting the process" "$name"
        if which start-stop-daemon > /dev/null 2>&1; then
            start-stop-daemon --chuid influxdb:influxdb --start --quiet --pidfile $pidfile --exec $daemon -- -pidfile $pidfile -config $config >>$STDOUT 2>>$STDERR &
        else
            nohup $daemon -pidfile $pidfile -config $config >>$STDOUT 2>>$STDERR &
        fi
        log_success_msg "$name process was started"
        echo $STDERR
        tail $STDERR
        ;;

    stop)
        # Stop the daemon.
        if [ -e $pidfile ]; then
            pidofproc -p $pidfile $daemon > /dev/null 2>&1 && status="0" || status="$?"
            if [ "$status" = 0 ]; then
                if killproc -p $pidfile SIGTERM && /bin/rm -rf $pidfile; then
                    log_success_msg "$name process was stopped"
                else
                    log_failure_msg "$name failed to stop service"
                fi
            fi
        else
            log_failure_msg "$name process is not running"
        fi
        ;;

    restart)
        # Restart the daemon.
        $0 stop && sleep 2 && $0 start
        ;;

    status)
        # Check the status of the process.
        if [ -e $pidfile ]; then
            if pidofproc -p $pidfile $daemon > /dev/null; then
                log_success_msg "$name Process is running"
                exit 0
            else
                log_failure_msg "$name Process is not running"
                echo $STDERR
                tail $STDERR
                exit 1
            fi
        else
            log_failure_msg "$name Process is not running"
            echo $STDERR
            tail $STDERR
            exit 3
        fi
        ;;

    version)
        $daemon version
        ;;

    *)
        # For invalid arguments, print the usage message.
        echo "Usage: $0 {start|stop|restart|status|version}"
        exit 2
        ;;
esac
