FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy --no-install-recommends install python-dev python-pip git python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy --no-install-recommends install python-pbr python-webob python-eventlet python-greenlet python-netaddr python-pastedeploy python-paste python-routes python-six python-sqlalchemy python-migrate python-iso8601 python-openssl python-crypto python-cffi python-keystoneclient python-keystonemiddleware python-swiftclient python-cinderclient python-oslo.config python-oslo.messaging python-oslo.db python-oslo.i18n python-oslo.vmware python-oslo.serialization python-oslo.concurrency python-retrying python-jsonschema python-posix-ipc python-suds python-boto python-crypto python-simplegeneric python-wsme python-osprofiler python-ipaddr python-glance-store

USER user
RUN \
 mkdir -p /tmp/git-fetch && \
 cd /tmp/git-fetch && \
 git init && \
 git fetch --depth 1 https://github.com/openstack/glance.git master && \
 git checkout FETCH_HEAD
WORKDIR /tmp/git-fetch
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install && cp -r etc /etc/glance && \
 /usr/local/bin/glance-api --help

# >=0.9.2 required for Ic6d53ed1fef8aee9471f3540f06b39cd5ee4ef82 fix in turn required for mysqlconnector
RUN pip install sqlalchemy-migrate\>=0.9.2

ADD glance-api.conf /etc/glance/glance-api.conf.in
ADD glance-registry.conf /etc/glance/glance-registry.conf.in
ADD glance-scrubber.conf /etc/glance/glance-scrubber.conf.in
ADD glance-cache.conf /etc/glance/glance-cache.conf.in
ADD glance-manage.conf /etc/glance/glance-manage.conf.in

ADD _wrap.sh /usr/local/bin/glance-api.sh
ADD _wrap.sh /usr/local/bin/glance-cache-cleaner.sh
ADD _wrap.sh /usr/local/bin/glance-cache-manage.sh
ADD _wrap.sh /usr/local/bin/glance-cache-prefetcher.sh
ADD _wrap.sh /usr/local/bin/glance-cache-pruner.sh
ADD _wrap.sh /usr/local/bin/glance-control.sh
ADD _wrap.sh /usr/local/bin/glance-manage.sh
ADD _wrap.sh /usr/local/bin/glance-registry.sh
ADD _wrap.sh /usr/local/bin/glance-replicator.sh
ADD _wrap.sh /usr/local/bin/glance-scrubber.sh

WORKDIR /
VOLUME ["/store", "/cache", "/lock"]
EXPOSE 9292 9191
