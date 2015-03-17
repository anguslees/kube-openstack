#!/bin/sh

set -e

. /home/install/venv/bin/activate

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

# TODO(gus): add support for env vars in openstack config files,
# instead of this code.
find $ETC_IN -type f -print |
    while read orig; do
	out=$ETC/${orig#$ETC_IN/}
	mkdir -p ${out%/*}
	case "$orig" in
	    *.in)
		out=${out%.in}
		perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' <$orig >$out
		;;
	    *)
		ln -sf $orig $out
		;;
	esac
    done

exec "$@"
