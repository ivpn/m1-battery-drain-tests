#!/bin/sh

cd "$(dirname "$0")"

_LOGFILE="batterylog.log"
rm ${_LOGFILE}

_STARTTIMESEC="$( date +%s )"

while true
do
  _BATTERY="$( pmset -g batt | grep "InternalBattery" | awk 'BEGIN {FS=";"; OFS=";"} {print $1}' | awk 'BEGIN {FS=" "; OFS=";"} {print $3}' | awk 'BEGIN {FS="%"; OFS=";"} {print $1}')"

  _DATE="$( date "+%d/%m/%y %H:%M:%S" )"
  _TIMESEC="$( date +%s )"
  _ELAPSEDSEC=$(($_TIMESEC - $_STARTTIMESEC))

  echo "${_DATE}; ${_ELAPSEDSEC}; ${_BATTERY}" >> ${_LOGFILE}
  echo "${_DATE}; ${_ELAPSEDSEC}sec; ${_BATTERY}"
  sleep 60
done
