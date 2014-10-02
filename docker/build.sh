#!/bin/sh

set -e -x

for d in keystone nova glance; do
    docker build -t localhost:4999/$d $d
    docker push localhost:4999/$d
done
