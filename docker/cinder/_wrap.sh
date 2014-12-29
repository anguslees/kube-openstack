#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/cinder/cinder.conf.in >/etc/cinder/cinder.conf

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
