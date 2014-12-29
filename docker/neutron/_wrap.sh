#!/bin/sh

set -e -x

realbin=${0%.sh}
PATH=$PATH:/usr/local/bin

: ${MY_IP:=$(hostname -i)}
: ${HOSTNAME:=$(hostname)}
export MY_IP HOSTNAME

for f in neutron.conf l3_agent.ini metadata_agent.ini plugins/ml2/ml2_conf.ini; do
    perl -ple 's/\$ENV\[(\w+)\]/$ENV{$1}/eg' </etc/neutron/$f.in >/etc/neutron/$f
done

#exec su --preserve-environment -s $realbin user -- "$@"
exec $realbin "$@"
