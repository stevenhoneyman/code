#!/bin/bash

# the original urlwatch is slow and buggy
# Source: https://github.com/keenerd/pkgbuild-watch

diffargs=""
cache="$HOME/.urlwatch/cache"
DATAFILE="$HOME/.urlwatch/urls.txt"

if [ $# -eq 1 ]; then
    DATAFILE="$1"
elif [ ! -f "$DATAFILE" ]; then
    echo "cheap bash knockoff of urlwatch"
    echo "urlwatch.sh url-list.txt"
    exit
fi

COLOR1='\e[1;32m'
ENDC='\e[0m'
mkdir -p "$cache"

nap()  # none : none
{
    while (( $(jobs | wc -l) >= 16 )); do
        sleep 0.1
        jobs > /dev/null
    done
}

urlcheck()  # url : pretty print
{
    urlhash=$(sha1sum <<< "$1" | cut -d ' ' -f 1)
    temp=$(mktemp)
    curl -s --connect-timeout 10 "$1" > "$temp"
    if [ ! -s "$temp" ]; then
        # failure, don't bother anyone with the diff
        rm -f "$temp"
        return
    fi
    html2text -o "$temp.txt" "$temp"
    if [ ! -e "$cache/$urlhash" ]; then
        cp "$temp.txt" "$cache/$urlhash"
    fi
    diff -q "$temp.txt" "$cache/$urlhash" &> /dev/null
    if [[ "$?" != "0" ]]; then
        diff $diffargs "$temp.txt" "$cache/$urlhash" > "$temp.diff"
        cp "$temp.txt" "$cache/$urlhash"
        # echo is atomic, fine for multithreaded stuff
        echo -e "${COLOR1}${1}${ENDC}\n$(cat $temp.diff)\n\n"
    fi
    rm -f $temp{,.txt,.diff}
}

while read line; do
    if echo -ne $line|grep -qv '^[#\n]'; then
        urlcheck "$line" &
        nap
    fi
done < "$DATAFILE"
wait
