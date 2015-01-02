FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-dev python-pip git python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy install python-pbr python-webob python-eventlet python-greenlet python-netaddr python-pastedeploy python-paste python-routes python-six python-sqlalchemy python-migrate python-passlib python-iso8601 python-keystoneclient python-keystonemiddleware python-oslo.config python-oslo.messaging python-oslo.db python-oslo.i18n python-oslo.utils python-oslo.serialization python-oslo.concurrency python-babel python-dogpile.cache python-jsonschema python-pycadf python-posix-ipc python-oauthlib

USER user
RUN \
 mkdir -p /tmp/git-fetch && \
 cd /tmp/git-fetch && \
 git init && \
 git fetch --depth 1 https://github.com/openstack/keystone.git master && \
 git checkout FETCH_HEAD
WORKDIR /tmp/git-fetch
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install && cp -r etc /etc/keystone

ADD keystone.conf /etc/keystone/keystone.conf.in
ADD catalog.templates /etc/keystone/catalog.templates.in
ADD _wrap.sh /usr/local/bin/keystone-all.sh
ADD _wrap.sh /usr/local/bin/keystone-manage.sh

WORKDIR /

EXPOSE 5000 35357
