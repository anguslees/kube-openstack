#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin
test -n "$COREOS_PUBLIC_IPV4" || . /etc/environment

perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/nova/nova.conf.in >/etc/nova/nova.conf

test "$RUN_NOVA_DB_SYNC" = true && nova-manage db sync

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
