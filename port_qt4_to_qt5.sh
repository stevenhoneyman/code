#!/bin/sh

#
# Save some time porting Qt4 source to Qt5
#

find . -type f -name "*.pro" -exec sed -i 's/^CONFIG.*$/&\nQT += widgets/' '{}' \;
find . -type f -exec sed -i 's/<QtGui>/<QtWidgets>/g' '{}' \;
find . -type f -exec sed -i 's/#include <QtGui\//#include </g' '{}' \;
find . -type f -exec sed -i 's/Qt::WFlags/Qt::WindowFlags/g' '{}' \;
find . -type f -exec sed -i 's/FALSE/false/g' '{}' \;
find . -type f -exec sed -i 's/fromAscii()/fromLatin1()/g' '{}' \;
find . -type f -exec sed -i 's/toAscii()/toLatin1()/g' '{}' \;
