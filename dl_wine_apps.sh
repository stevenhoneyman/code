#!/bin/sh
#
# dl_wine_apps.sh - downloads & unpacks some free stuff that
#                   doesnt have a good linux alternative
#
# Pre-reqs: cabextract, md5deep, unzip, wget
#
# 2014-06-30 Steven Honeyman <stevenhoneyman at gmail com>
#

TEMPDIR=$(mktemp -d)
CACHEDIR="/dev/shm/cache"
DESTDIR="/dev/shm/wine_apps"
#WINEARCH=win32

mkdir -p "$DESTDIR"
mkdir -p "$CACHEDIR"/_archives

#-----------------------------------------------------------------
