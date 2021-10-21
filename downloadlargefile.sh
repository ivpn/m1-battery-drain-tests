#!/bin/sh

cd "$(dirname "$0")"

_LOGFILE="download.log"
_LOGFILE_ERR="download_error.log"
_LINKS=(
"https://fedora.astra.in.ua//releases/34/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-34-1.2.iso"
"https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-desktop-amd64.iso"
"https://download.microsoft.com/download/8/4/7/8474c424-ddc8-4c56-bf19-25b29a9cb437/WinDev2108Eval.VMware.zip"
)

_TMPFILE="test.tmp"

rm ${_TMPFILE}
rm ${_LOGFILE}
rm ${_LOGFILE_ERR}

_TOTALBYTES=0
_STARTTIMESEC="$( date +%s )"
echo "TIME\t;\tELAPSED\t;\tFILE_DOWNLOAD_TIME\t;\tBYTES\t;\tAVGSPEED\t;\tTOTAL BYTES\t;\tFILE LINK" > ${_LOGFILE}
while true
do
  for _FILETODOWNLOAD in ${_LINKS[@]}; do
     echo "[!] ============================================"
     echo "[!] Downloading: '$_FILETODOWNLOAD'"
     rm ${_TMPFILE}

     _FILE_DOWNLOAD_STARTTIMESEC="$( date +%s )"

     _DATE="$( date "+%d/%m/%y %H:%M:%S" )"
     curl ${_FILETODOWNLOAD} --output ${_TMPFILE}
     if ! [ $? -eq 0 ]; then
       echo ${_DATE} : ${_FILETODOWNLOAD} >> ${_LOGFILE_ERR}
       echo "<<< ERROR! Pause 3 seconds >>>"
       sleep 3
       continue
     fi

     _BYTES="$( stat -f%z ${_TMPFILE} )"
     _TIMESEC="$( date +%s )"

     _TOTALBYTES=$(($_TOTALBYTES + $_BYTES))

     _ELAPSEDSEC=$(($_TIMESEC - $_STARTTIMESEC))
     _FILE_DOWNLOAD_ELAPSEDSEC=$(($_TIMESEC - $_FILE_DOWNLOAD_STARTTIMESEC))

     _AVGDLOADSPEED_KBPS=$((($_BYTES / $_FILE_DOWNLOAD_ELAPSEDSEC) / 1024))

     echo ">> DATE:${_DATE}\tELAPSED=${_ELAPSEDSEC} sec\tFILE_DOWNLOAD_TIME=${_FILE_DOWNLOAD_ELAPSEDSEC} sec\tDOWNLOADED=${_BYTES} bytes\tAVGSPEED=${_AVGDLOADSPEED_KBPS} kilobytes/sec \tTOTAL:${_TOTALBYTES} bytes"
     echo "${_DATE}\t;\t${_ELAPSEDSEC}\t;\t${_FILE_DOWNLOAD_ELAPSEDSEC}\t;\t${_BYTES}\t;\t${_AVGDLOADSPEED_KBPS}\t;\t${_TOTALBYTES}\t;\t${_FILETODOWNLOAD}" >> ${_LOGFILE}
  done

done
