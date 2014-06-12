#!/bin/sh
#
# mkfakelib.sh - create dummy libraries to save disk space
# v1.0 2014-06-12 Steven Honeyman <stevenhoneyman at gmail com>
#
# Usage: mkfakelib.sh libavahi-client.so.3.2.9
#
# This script works well on pesky avahi libraries, which libreoffice
# packaged for Arch Linux won't start without... but works fine with
# these dummy libraries!
#

# tcc makes these smaller than gcc (~7kb vs ~13kb)
COMPILER=tcc

#################

if [ ! -f "$1" ]; then
	echo 'missing parameter: library.so'
	exit 1
fi

FAKELIBSRC=$(mktemp fakelib_XXXXXX.c)
FAKELIBOBJ=$(mktemp fakelib_XXXXXX.o)

nm -D "$1" | awk '/^0.*T[[:space:]]/&&$3!~'/^_/' {print "void "$3"(void) {}"}' | sort -u >$FAKELIBSRC
$COMPILER -c -fpic $FAKELIBSRC -o $FAKELIBOBJ
$COMPILER -s -shared $FAKELIBOBJ -o "$(basename $1).fake"
rm $FAKELIBSRC $FAKELIBOBJ

echo "$(basename $1).fake created"
