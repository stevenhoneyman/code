#!/bin/sh
#
# lesspipe.sh - auto highlight syntax in less.
# 2014-06-21 Steven Honeyman <stevenhoneyman at gmail com>
#
# Usage: in ~/.bashrc (etc), add:
#   export LESSOPEN="|- lesspipe.sh %s"
#

if [ -t 0 ]; then
  for source in "$@"; do
	if file -b --mime-type "$source" | grep -q 'text'; then
		case $source in
		*ChangeLog|*changelog)
				source-highlight --failsafe -f esc256 --lang-def=changelog.lang --style-file=esc256.style -i "$source" ;;
		*Makefile|*makefile)
				source-highlight --failsafe -f esc256 --lang-def=makefile.lang --style-file=esc256.style -i "$source" ;;
		*.awk|*.groff|*.java|*.js|*.m4|*.php|*.pl|*.pm|*.pod|*.sh|\
			*.ad[asb]|*.asm|*.inc|*.[ch]|*.[ch]pp|*.[ch]xx|*.cc|*.hh|\
			*.lsp|*.l|*.pas|*.p|*.xml|*.xps|*.xsl|*.axp|*.ppd|*.pov|\
			*.py|*.rb|*.sql|*.ebuild|*.eclass|.bashrc|.bash_aliases|.bash_functions)
			source-highlight --failsafe --infer-lang -f esc256 --style-file=esc256.style -n -i "$source" ;;
			*)  source-highlight --failsafe --infer-lang -f esc256 --style-file=esc256.style -i "$source" ;;
		esac
	else
		# without the check, "less --help" errors when xxd tries to open it
		if [ -f "$source" ]; then xxd -c 20 "$source"; fi
	fi
  done
else
    stdintemp=$(mktemp)
    cat /dev/stdin > $stdintemp
    MIME=$(file -b --mime-type $stdintemp)
    if echo $MIME | grep -q 'text'; then
	case $MIME in
	    text/x-c)
		source-highlight --failsafe --lang-def=c.lang -f esc256 --style-file=esc256.style -n -i "$stdintemp" ;;
	    text/x-shellscript)
		source-highlight --failsafe --lang-def=sh.lang -f esc256 --style-file=esc256.style -n -i "$stdintemp" ;;
	    text/x-diff)
		source-highlight --failsafe --lang-def=diff.lang -f esc256 --style-file=esc256.style -i "$stdintemp" ;;
	    text/x-python)
		source-highlight --failsafe --lang-def=python.lang -f esc256 --style-file=esc256.style -n -i "$stdintemp" ;;
	    text/x-perl)
		source-highlight --failsafe --lang-def=perl.lang -f esc256 --style-file=esc256.style -n -i "$stdintemp" ;;
	    text/x-sql)
		source-highlight --failsafe --lang-def=sql.lang -f esc256 --style-file=esc256.style -n -i "$stdintemp" ;;
	    *)  cat "$stdintemp" ;;
	esac
    else
        xxd -c 20 "$stdintemp"
    fi
    rm -f "$stdintemp"
fi
