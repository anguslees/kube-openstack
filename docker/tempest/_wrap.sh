#!/bin/sh

set -e -x

realbin=/usr/local/bin/tempest_user.sh
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

for f in /etc/tempest/tempest.conf; do
    perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' <$f.in >$f
done

#exec $realbin "$@"
exec su --preserve-environment -s $realbin user -- "$@"
