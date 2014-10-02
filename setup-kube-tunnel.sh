#!/bin/sh

set -x

exec nova ssh --login core --extra-opts '-o StrictHostKeyChecking=no -o UserKnownHostsFile=~/.ssh/nova_known_hosts -f -nNT -L 8080:127.0.0.1:8080' kubernetes-master-0
