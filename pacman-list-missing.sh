#!/bin/sh
#
# Lists files missing from system, excluding the ones not extracted due to NoExtract settings.
#
pacman -Qk 2>&1 | awk '{if(NR==FNR){if($0~/^NoExtract/)for(i=0;i<=NF;i++){if($i!~/^NoExtract|=|^!/){gsub("/","\\/",$i);gsub("\\.","\\.",$i);gsub("?",".",$i);gsub("*",".*",$i);a[$i]++;}}}else{m=0;if($1~/^warning/){for(r in a){if($3~r){m=1;break}};if(m==0){print $3}}}}' /etc/pacman.conf -
