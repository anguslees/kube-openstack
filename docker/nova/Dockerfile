FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-dev python-pip git python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy install python-anyjson python-argparse python-babel python-paramiko python-jinja2 python-netaddr python-suds python-pyasn1 python-iso8601 python-jsonschema python-pycadf python-lxml python-webob python-greenlet python-pastescript python-pastedeploy python-migrate python-eventlet python-sqlalchemy python-boto python-kombu websockify python-oslo.concurrency python-keystonemiddleware python-keystoneclient python-routes python-cinderclient python-neutronclient python-glanceclient python-oslo.concurrency python-oslo.serialization python-oslo.utils python-oslo.db python-oslo.rootwrap python-simplejson

RUN apt-get -qqy install iproute2 python-amqplib python-configobj python-iso8601 iptables

USER user
RUN \
 mkdir -p /tmp/git-fetch && \
 cd /tmp/git-fetch && \
 git init && \
 git fetch --depth 1 https://github.com/openstack/nova.git master && \
 git checkout FETCH_HEAD
WORKDIR /tmp/git-fetch
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install && cp -r etc/nova /etc/nova

ADD nova.conf /etc/nova/nova.conf.in

ADD _wrap.sh /usr/local/bin/nova-manage.sh
ADD _wrap.sh /usr/local/bin/nova-api.sh
ADD _wrap.sh /usr/local/bin/nova-api-ec2.sh
ADD _wrap.sh /usr/local/bin/nova-api-metadata.sh
ADD _wrap.sh /usr/local/bin/nova-api-os-compute.sh
ADD _wrap.sh /usr/local/bin/nova-cells.sh
ADD _wrap.sh /usr/local/bin/nova-cert.sh
ADD _wrap.sh /usr/local/bin/nova-compute.sh
ADD _wrap.sh /usr/local/bin/nova-conductor.sh
ADD _wrap.sh /usr/local/bin/nova-novncproxy.sh
ADD _wrap.sh /usr/local/bin/nova-scheduler.sh
ADD _wrap.sh /usr/local/bin/nova-spicehtml5proxy.sh
ADD _wrap.sh /usr/local/bin/nova-xvpnvcproxy.sh

WORKDIR /
EXPOSE 8773 8774 8775
