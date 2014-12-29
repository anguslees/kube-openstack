#!/bin/sh

set -e -x

realbin=/usr/local/bin/tempest_user.sh
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/tempest/tempest.conf.in >/etc/tempest/tempest.conf

#exec $realbin "$@"
exec su --preserve-environment -s $realbin user -- "$@"
