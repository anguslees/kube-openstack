FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-dev python-pip git python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy install python-pbr python-paste python-pastedeploy python-routes python-anyjson python-argparse python-babel python-eventlet python-greenlet python-httplib2 python-requests python-iso8601 python-jsonrpclib python-jinja2 python-keystonemiddleware python-netaddr python-neutronclient python-sqlalchemy python-webob python-keystoneclient python-alembic python-six python-stevedore python-oslo.config python-oslo.db python-oslo.messaging python-oslo.rootwrap python-oslo.serialization python-novaclient python-oslo.concurrency

RUN apt-get -qqy install dnsmasq-utils dnsmasq-base iputils-arping ipset

USER user
RUN \
 mkdir -p /tmp/git-fetch && \
 git init && \
 git fetch --depth 1 https://github.com/openstack/neutron.git master && \
 git checkout FETCH_HEAD
WORKDIR /tmp/git-fetch
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
# neutron git repo has files in both etc/ and etc/neutron
RUN python setup.py install && \
 mkdir -p /etc/neutron && \
 cp -r etc/* /etc/neutron/ && \
 mv /etc/neutron/neutron/* /etc/neutron/ && \
 rmdir /etc/neutron/neutron

# >=0.9.2 required for Ic6d53ed1fef8aee9471f3540f06b39cd5ee4ef82 fix in turn required for mysqlconnector
RUN pip install sqlalchemy-migrate\>=0.9.2

ADD neutron.conf /etc/neutron/neutron.conf.in
ADD l3_agent.ini /etc/neutron/l3_agent.ini.in
ADD metadata_agent.ini /etc/neutron/metadata_agent.ini.in
ADD ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini.in

ADD _wrap.sh /usr/local/bin/neutron-server.sh
ADD _wrap.sh /usr/local/bin/neutron-dhcp-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-l3-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-lbaas-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-metadata-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-openvswitch-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-vpn-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-metering-agent.sh
ADD _wrap.sh /usr/local/bin/neutron-db-manage.sh

WORKDIR /
EXPOSE 9696 9697
