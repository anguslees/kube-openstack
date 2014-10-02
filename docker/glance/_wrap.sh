#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

for f in glance-api glance-registry; do
    perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/glance/$f.conf.in >/etc/glance/$f.conf
done

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
