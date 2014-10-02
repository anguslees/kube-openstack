FROM ubuntu:utopic
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-dev python-pip git
RUN apt-get -qqy install python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy install python-pbr python-webob python-eventlet python-greenlet python-netaddr python-pastedeploy python-paste python-routes python-six python-sqlalchemy python-migrate python-iso8601 python-keystoneclient python-keystonemiddleware python-swiftclient python-cinderclient python-oslo.config python-oslo.messaging python-oslo.db python-oslo.i18n python-oslo.vmware python-retrying python-jsonschema python-posix-ipc python-suds python-boto python-crypto python-simplegeneric python-wsme python-osprofiler python-ipaddr python-glance-store

USER user
RUN mkdir -p /tmp/git-fetch
WORKDIR /tmp/git-fetch
RUN git init
RUN git fetch --depth 1 https://github.com/openstack/glance.git master
#RUN git fetch --depth 1 https://review.openstack.org/openstack/glance refs/changes/48/110848/1
RUN git checkout FETCH_HEAD
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install
RUN mkdir -p /etc
RUN cp -r etc /etc/glance

WORKDIR /

ADD glance-api.conf /etc/glance/glance-api.conf.in
ADD glance-registry.conf /etc/glance/glance-registry.conf.in

ADD _wrap.sh /usr/local/bin/glance-api.sh
ADD _wrap.sh /usr/local/bin/glance-registry.sh
ADD _wrap.sh /usr/local/bin/glance-scrubber.sh
ADD _wrap.sh /usr/local/bin/glance-manage.sh

VOLUME ["/store", "/cache", "/lock"]
EXPOSE 9292 9191
