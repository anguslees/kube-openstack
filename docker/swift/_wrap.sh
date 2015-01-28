#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

for f in /etc/swift/*.conf.in; do
    perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' <$f >${f%.in}
done

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
