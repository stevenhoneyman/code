#!/bin/sh

#
# Save some time porting Qt4 source to Qt5
#

echo '+ Fixing .pro files'
find . -type f -name "*.pro" -exec sed -i 's/^CONFIG.*$/&\nQT += widgets/' '{}' \;
echo '+ Updating QtGui -> QtWidgets'
find . -type f -exec sed -i 's/<QtGui>/<QtWidgets>/g' '{}' \;
echo '+ Removing unnecessary parts of #includes'
find . -type f -exec sed -i 's/#include <QtGui\//#include </g' '{}' \;
echo '+ Updating WFlags -> WindowFlags'
find . -type f -exec sed -i 's/Qt::WFlags/Qt::WindowFlags/g' '{}' \;
echo '+ Lower case FALSE'
find . -type f -exec sed -i 's/FALSE/false/g' '{}' \;
echo '+ Lower case TRUE'
find . -type f -exec sed -i 's/TRUE/true/g' '{}' \;
echo '+ fromAscii'
find . -type f -exec sed -i 's/fromAscii(/fromLatin1(/g' '{}' \;
echo '+ toAscii'
find . -type f -exec sed -i 's/toAscii(/toLatin1(/g' '{}' \;
echo '+ X11 -> UNIX for detection'
find . -type f -exec sed -i 's/Q_WS_X11/Q_OS_UNIX/g' '{}' \;
echo '+ Qt::escape -> toHtmlEscaped [might not work 100%]'
find . -type f -exec sed -i 's/Qt::escape(\(.*\)));/\1.toHtmlEscaped());/' '{}' \;
echo '+ QHeaderView: setResizeMode -> setSectionResizeMode'
find . -type f -exec sed -i 's/setResizeMode(/setSectionResizeMode(/g' '{}' \;
echo '+ QHeaderView: setClickable -> setSectionsClickable'
find . -type f -exec sed -i 's/setClickable(/setSectionsClickable(/g' '{}' \;
echo '+ QDesktopServices::storageLocation -> QStandardPaths::writableLocation'
find . -type f -exec sed -i 's/QDesktopServices::storageLocation(/QStandardPaths::writableLocation(/g' '{}' \;
echo '+ QDesktopServices::DocumentsLocation -> QStandardPaths::DocumentsLocation'
find . -type f -exec sed -i 's/QDesktopServices::DocumentsLocation/QStandardPaths::DocumentsLocation/g' '{}' \;

echo '+ Fixing any missing QDrag include'
for qdragfile in $(grep -lr 'QDrag' .); do
	if ! grep -q '#include <QDrag>' $qdragfile; then
		sed -i '0,/^#include/{s/#include.*$/&\n#include <QDrag>/}' $qdragfile
	fi;
done

echo '+ Fixing any missing QMimeData include'
for qmimefile in $(grep -lr 'QMimeData' .); do
	if ! grep -q '#include <QMimeData>' $qmimefile; then
		sed -i '0,/^#include/{s/#include.*$/&\n#include <QMimeData>/}' $qmimefile
	fi;
done


