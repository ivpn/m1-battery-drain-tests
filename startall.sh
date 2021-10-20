#!/bin/sh

cd "$(dirname "$0")"

rm -f "*.log"
rm -f "*.tmp"
rm -fr "batterylog"

open  -b com.apple.terminal ./getbatterystatus.sh &
open  -b com.apple.terminal ./processpowermetricks.sh &
open  -b com.apple.terminal ./downloadlargefile.sh &
