#!/bin/bash
#
# benchmark-exec-time.sh - Run a command n times and show average exec time
# 2014-06-28 Steven Honeyman <stevenhoneyman at gmail com>
#
# Usage: benchmark-exec-time.sh <numRuns> <command>
#

if [[ $# -lt 2 ]]; then
    echo 'Usage: benchmark-exec-time.sh <numRuns> <command>'
    echo ' $ benchmark-exec-time.sh 100 sleep 5'
    echo ' $ V=1 benchmark-exec-time.sh 10 testscript'
    exit 1
fi

logFile=$(mktemp benchmark-XXXXX.log)
TIMEFORMAT="%3R"
total=0
numRuns=$1; shift

for r in $(seq 1 $numRuns); do
    [ ! -z $V ] && echo "run $r... "
    { time $@ >/dev/null || exit 1; } 2>>$logFile
done

echo " Done. calculating..."
while read i; do
    total=$(bc<<<"$total+$i")
done < ${logFile}
rm $logFile

echo " Completed $numRuns runs of: '$@' in $total seconds"
echo " Average run time was: $(bc<<<"scale=3;$total/$numRuns") seconds"
