#!/bin/sh

# TODO(gus): If _wrap.sh sourced files in a directory somewhere, then
# this additional wrapper would be unnecessary.
. /home/user/openrc

exec /usr/local/bin/_wrap.sh run-tempest-stress "$@"
