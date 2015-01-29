FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy --no-install-recommends install python-dev python-pip git python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy --no-install-recommends install python-pbr python-anyjson python-argparse python-babel python-eventlet python-greenlet python-iso8601 python-keystonemiddleware python-kombu python-lxml python-netaddr python-oslo.config python-oslo.db python-oslo.messaging python-oslo.rootwrap python-paramiko python-paste python-pastedeploy python-crypto python-glanceclient python-novaclient python-swiftclient python-requests python-routes python-taskflow python-rtslib-fb python-six python-sqlalchemy python-migrate python-stevedore python-suds python-webob python-wsgiref python-oslo.i18n python-oslo.serialization python-oslo.concurrency python-barbicanclient python-osprofiler python-xattr

USER user
RUN \
 mkdir -p /tmp/git-fetch && \
 cd /tmp/git-fetch && \
 git init && \
 git fetch --depth 1 https://github.com/openstack/cinder.git master && \
 git checkout FETCH_HEAD
WORKDIR /tmp/git-fetch
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install && \
 mkdir -p /etc/cinder && \
 cp -r etc/cinder/* /etc/cinder/ && \
 /usr/local/bin/cinder-api --help

# >=0.9.2 required for Ic6d53ed1fef8aee9471f3540f06b39cd5ee4ef82 fix in turn required for mysqlconnector
RUN pip install sqlalchemy-migrate\>=0.9.2

WORKDIR /

ADD cinder.conf /etc/cinder/cinder.conf.in

ADD _wrap.sh /usr/local/bin/cinder-api.sh
ADD _wrap.sh /usr/local/bin/cinder-volume.sh
ADD _wrap.sh /usr/local/bin/cinder-scheduler.sh
ADD _wrap.sh /usr/local/bin/cinder-backup.sh
ADD _wrap.sh /usr/local/bin/cinder-manage.sh
ADD _wrap.sh /usr/local/bin/cinder-rtstool.sh
ADD _wrap.sh /usr/local/bin/cinder-volume-usage-audit.sh

EXPOSE 8776
