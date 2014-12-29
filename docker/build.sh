#!/bin/sh

set -e -x

set -- keystone nova glance cinder neutron openstack-client tempest

for d; do
    docker build -t localhost:4999/$d $d
    docker push localhost:4999/$d
done
