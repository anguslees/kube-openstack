#!/bin/sh

# Must match --minion_regexp in fleet/kube-controller-manager.service
name_prefix=testkube-minion-

set -x

key=gus-hounddog
vmnet=testkube-minion-net

for i in $(seq 1 5); do
    nova boot \
	--flavor performance1-8 \
	--image 'CoreOS (Beta)' \
	--key-name $key \
	--user-data minion.yaml \
	--config-drive true \
	--nic net-id=$vmnet \
	"$name_prefix$i"
done
