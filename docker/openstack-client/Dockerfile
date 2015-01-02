FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get -qqy install python-openstackclient python-keystoneclient python-novaclient python-swiftclient python-glanceclient python-neutronclient python-ceilometerclient python-cinderclient python-heatclient python-troveclient

USER user
ADD openrc /home/user/openrc
ADD bashrc /home/user/.bashrc

WORKDIR /home/user
ENTRYPOINT ["/bin/bash"]
