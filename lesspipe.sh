#!/bin/sh
#
# lesspipe.sh - preprocessor for less.
# 2014-06-28 Steven Honeyman <stevenhoneyman at gmail com>
#
# Usage: in ~/.bashrc (etc), add:
#   export LESSOPEN="|- lesspipe.sh %s"
#

SRC_HLT_CMD="source-highlight --failsafe --tab=4 -f esc256-steven --style-file=esc256-steven.style "

show_unknown() {
    file "$1"
    file "$1" --mime
    echo
    xxd -c 20 "$1"
}

if [ -t 0 ]; then
  for source in "$@"; do
    if [ ! -e "$source" ] && [ ! -z $(type -P "$source") ]; then
	source=$(type -P "$source")
    fi
    if file -b --mime-type "$source" | grep -q 'text\|xml'; then
	case $source in
	    *ChangeLog|*changelog)  	$SRC_HLT_CMD --lang-def=changelog.lang -i "$source" ;;
	    *Makefile|*makefile)    	$SRC_HLT_CMD --lang-def=makefile.lang -i "$source" ;;
	    .bashrc|.bash_*|PKGBUILD*)	$SRC_HLT_CMD --lang-def=sh.lang -n -i "$source" ;;
	    *.awk|*.groff|*.java|*.js|*.m4|*.php|*.pl|*.pm|*.pod|*.sh|\
		*.ad[asb]|*.asm|*.inc|*.[ch]|*.[ch]pp|*.[ch]xx|*.cc|*.hh|\
		*.lsp|*.l|*.pas|*.p|*.xml|*.xps|*.xsl|*.axp|*.ppd|*.pov|\
		*.py|*.rb|*.sql|*.ebuild|*.eclass)
				    $SRC_HLT_CMD --infer-lang -n -i "$source" ;;
	    *.1)  		    mandoc "$source" ;;
	    *)    		    $SRC_HLT_CMD --infer-lang -i "$source" ;;
	esac
    elif [[ "$source" == *share/man/man* ]]; then
	gzip -cdfq "$source" | mandoc
    else
	# without the check, "less --help" errors when xxd tries to open it
	[ -f "$source" ] && show_unknown "$source"
    fi
  done
else
    stdintemp=$(mktemp)
    cat /dev/stdin > $stdintemp
    MIME=$(file -b --mime-type $stdintemp)
    if echo $MIME | grep -q 'text\|xml'; then
	case $MIME in
	    text/x-c) 		$SRC_HLT_CMD --lang-def=c.lang -n -i "$stdintemp" ;;
	    text/x-shellscript)	$SRC_HLT_CMD --lang-def=sh.lang -n -i "$stdintemp" ;;
	    text/x-diff)	$SRC_HLT_CMD --lang-def=diff.lang -i "$stdintemp" ;;
	    text/x-python)	$SRC_HLT_CMD --lang-def=python.lang -n -i "$stdintemp" ;;
	    text/x-perl)	$SRC_HLT_CMD --lang-def=perl.lang -n -i "$stdintemp" ;;
	    text/x-sql)		$SRC_HLT_CMD --lang-def=sql.lang -n -i "$stdintemp" ;;
	    application/xml)	$SRC_HLT_CMD --lang-def=xml.lang -n -i "$stdintemp" ;;
	    text/troff)  	mandoc "$stdintemp" ;;
	    *)  		cat "$stdintemp" ;;
	esac
    else
        show_unknown "$stdintemp"
    fi
    rm -f "$stdintemp"
fi
