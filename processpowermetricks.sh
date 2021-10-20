#!/bin/sh

cd "$(dirname "$0")"

_LOGDIR="batterylog"

rm -fr ${_LOGDIR}
mkdir ${_LOGDIR}

_STARTTIMESEC="$( date +%s )"

while true
do
  sudo powermetrics --show-initial-usage --show-process-energy -s tasks -n 0  | grep 'wireguard\|IVPN\|openvpn\|obfs' |
  while IFS= read -r line; do
    _FNAME="$( echo "$line" | awk 'BEGIN {FS="  "} {print $1}' )"

    _DATE="$( date "+%d/%m/%y %H:%M:%S" )"
    _TIMESEC="$( date +%s )"
    _ELAPSEDSEC=$(($_TIMESEC - $_STARTTIMESEC))

    _FULLFNAME="${_LOGDIR}/${_FNAME}.log"
    if [ ! -f "${_FULLFNAME}" ]; then
      echo "[DATE]\t[ELAPSED sec]\t[Name]\t[ID]\t[CPU ms/s]\t[User]\tDeadlines (<2 ms, 2-5 ms)\tWakeups (Intr, Pkg idle)\t[Energy Impact]" > "${_FULLFNAME}"
    fi

    echo "$_DATE    $_ELAPSEDSEC    $line" >> "${_FULLFNAME}"
    echo "$_DATE    $_ELAPSEDSEC    $line"
  done
  sleep 60
done
