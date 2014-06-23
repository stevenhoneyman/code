#!/bin/bash
#
# Shows 16 color terminal stuff, inc formatting
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
#

#Foreground
for clfg in {30..37} {90..97} 39 ; do
	#Formatting
	for attr in 0 1 2 4 5 7 ; do
		#Print the result
		echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
	done
	echo #Newline
done
