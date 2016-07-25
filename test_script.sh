#!/bin/bash

LOAD=90.00
MEM_PERCENT=95.00
SYS_MEM=95.00
CPU_UTIL=`sar -P ALL 1 2 |grep 'Average.*all' |awk -F" " '{print 100.0 -$NF}'`
USED_MEM=`free | awk '/Mem/{printf("used: %.2f%\n"), $3/$2*100}' | awk '{print $2}' | cut -d"%" -f1`

df -H | grep -vE '^Filesystem|tmpfs|cdrom|mapper' | grep sd | awk '{ print $5 " " $1 }' | while read output
do
  echo $output
  USED_PERCENT=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )  
  if (( $(bc <<< "$USED_PERCENT > $LOAD") )) || (( $(bc <<< "$CPU_UTIL > $MEM_PERCENT") )) || (( $(bc <<< "$USED_MEM > $SYS_MEM") ))
  then
     echo  "System resource are above the threshold value" | mail -s "System resources"  helloassignment1@gmail.com
  else
     echo "This is  a test"
  fi
done

echo "CPU Utilization: $CPU_UTIL"

echo "Used Memory: $USED_MEM"

#To make the script run for every 5 minutes, add the following entry to crontab
#*/5 * * * * sh /path-of-the-script/test_script.sh

