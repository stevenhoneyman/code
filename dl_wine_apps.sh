#!/bin/sh
#
# Filename: dl_wine_apps.sh
# Desc:     downloads & unpacks some free stuff that doesnt have a good linux alternative
# Date:     2014-06-30
# URL:      https://github.com/stevenhoneyman/code/blob/master/dl_wine_apps.sh
# Author:   Steven Honeyman <stevenhoneyman at gmail com>
#
# Pre-reqs: cabextract, md5deep, unzip, wget
#

#----------------------------------------------------------------
# SETTINGS
#----------------------------------------------------------------

# The contents of TEMPDIR and DESTDIR may be overwritten
TEMPDIR=$(mktemp -d)
DESTDIR="/dev/shm/wine_apps"

# CACHEDIR keeps downloaded files to save bandwidth for re-runs
CACHEDIR="/dev/shm/cache"

# Uncomment if appropriate. If you're still on a 32-bit install,
# also uncomment this to cause any 64 bit stuff to be avoided.
#
#WINEARCH=win32

#----------------------------------------------------------------

mkdir -p "$DESTDIR" "$CACHEDIR"/_archives

if [ ! -f "$CACHEDIR/.checksums" ]; then cat <<EOF >"$CACHEDIR/.checksums"
e157e75fe121117d3403269d8bdbe20b  KB2584577.exe
163e6a714993d4bf0056ba334cd6a85a  KB978706.exe
EOF
fi

function isCached() {
    if [ -f "${CACHEDIR}/$1" ]; then
	echo -n "$1 found in $CACHEDIR... "
	checkMD5 "${CACHEDIR}/$1"
    else
	return 1;
    fi
}

function checkMD5() {
    if [ -f "$1" ]; then
	local r=$(md5deep -X "$CACHEDIR/.checksums" -bw "$1")
	if [ -z "$r" ]; then
	    echo "OK"
	    return 0
	else
	    echo -e "\n$r"
	    exit 1 #TODO: something else here
	fi
    else
	return 1;
    fi
}

# x86,x64 mfc42u.dll (required for mspaint)
# e157e75fe121117d3403269d8bdbe20b  WindowsServer2003-KB2584577-x64-ENU.exe
#   1462272 | 22.11.2011 14:32:16 | SP2QFE/mfc42.dll
#   1454080 | 22.11.2011 14:32:18 | SP2QFE/mfc42u.dll
#   1163264 | 22.11.2011 14:32:18 | SP2QFE/wow/wmfc42.dll
#   1165824 | 22.11.2011 14:32:18 | SP2QFE/wow/wmfc42u.dll

if ! isCached "_archives/KB2584577.exe"; then
    echo -n " ==> Downloading Microsoft Update KB2584577... "
    wget -q -P "$TEMPDIR" http://hotfixv4.microsoft.com/Windows%20Server%202003/sp3/Fix391182/3790/free/440964_ENU_x64_zip.exe
    unzip -p "$TEMPDIR"/440964_ENU_x64_zip.exe >"$CACHEDIR"/_archives/KB2584577.exe
    checkMD5 "$CACHEDIR"/_archives/KB2584577.exe && rm "$TEMPDIR"/440964_ENU_x64_zip.exe
fi

# x86,x64 MSPaint
# 163e6a714993d4bf0056ba334cd6a85a  WindowsServer2003.WindowsXP-KB978706-x64-ENU.exe
#    570368 | 17.12.2009 16:57:20 | SP2GDR/mspaint.exe
#    343552 | 17.12.2009 16:57:20 | SP2GDR/wow/wmspaint.exe

mkdir -p "$DESTDIR"/mspaint
if ! isCached "_archives/KB978706.exe"; then
    echo -n " ==> Downloading Microsoft Update KB978706... "
    wget -q -O "$CACHEDIR"/_archives/KB978706.exe http://download.microsoft.com/download/0/9/0/090233F4-CD1F-4B86-906B-D74E6F43B820/WindowsServer2003.WindowsXP-KB978706-x64-ENU.exe
    checkMD5 "$CACHEDIR"/_archives/KB978706.exe
fi

if [ "$WINEARCH" == "win32" ]; then
    cabextract -p "$CACHEDIR"/_archives/KB978706.exe -F 'SP2GDR/wow/wmspaint.exe' >"$DESTDIR"/mspaint/mspaint.exe
    cabextract -p "$CACHEDIR"/_archives/KB2584577.exe -F 'sp2qfe/wow/wmfc42u.dll' >"$DESTDIR"/mspaint/mfc42u.dll
else
    cabextract -p "$CACHEDIR"/_archives/KB978706.exe -F 'SP2GDR/mspaint.exe' >"$DESTDIR"/mspaint/mspaint.exe
    cabextract -p "$CACHEDIR"/_archives/KB2584577.exe -F 'sp2qfe/mfc42u.dll' >"$DESTDIR"/mspaint/mfc42u.dll
fi

echo "Cleaning up any leftover temporary files..."
rm -rf "${TEMPDIR}"
