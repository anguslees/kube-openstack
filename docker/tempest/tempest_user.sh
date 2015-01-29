#!/bin/sh

. /home/user/openrc

exec /usr/local/bin/run-tempest-stress "$@"
