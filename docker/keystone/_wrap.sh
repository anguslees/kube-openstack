#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

for f in /etc/keystone/*.in; do
    perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' <$f >${f%.in}
done

test "$RUN_KEYSTONE_DB_SYNC" = true && keystone-manage db_sync

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
