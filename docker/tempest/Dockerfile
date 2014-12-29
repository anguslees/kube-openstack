FROM ubuntu:utopic
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-dev python-pip git
RUN apt-get -qqy install python-mysql.connector

# Fetch as much as we can from apt
RUN apt-get -qqy install python-pbr python-anyjson python-httplib2 python-jsonschema python-testtools python-lxml python-boto python-paramiko python-netaddr python-ceilometerclient python-glanceclient python-keystoneclient python-novaclient python-neutronclient python-cinderclient python-heatclient python-ironicclient python-saharaclient python-swiftclient python-testresources python-testrepository python-oslo.config python-six python-iso8601 python-fixtures python-testscenarios

USER user
RUN mkdir -p /tmp/git-fetch
WORKDIR /tmp/git-fetch
RUN git init
RUN git fetch --depth 1 https://github.com/openstack/tempest.git master
#RUN git fetch --depth 1 https://review.openstack.org/openstack/tempest refs/changes/48/110848/1
RUN git checkout FETCH_HEAD
USER root
RUN pip install -r requirements.txt
USER user
RUN python setup.py build
USER root
RUN python setup.py install
RUN mkdir -p /etc/tempest
RUN cp -r etc/* /etc/tempest/

WORKDIR /

ADD tempest.conf /etc/tempest/tempest.conf.in

ADD _wrap.sh /usr/local/bin/tempest.sh
ADD tempest_user.sh /usr/local/bin/tempest_user.sh

ENTRYPOINT ["/usr/local/bin/tempest.sh"]
