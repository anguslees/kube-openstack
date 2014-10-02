#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/keystone/keystone.conf.in >/etc/keystone/keystone.conf

test "$RUN_KEYSTONE_DB_SYNC" = true && keystone-manage db_sync

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
