FROM ubuntu:utopic
MAINTAINER Angus Lees <gus@inodes.org>

RUN \
 apt-get -q update && \
 apt-get -qy --no-install-recommends install \
 software-properties-common && \
 apt-key adv --recv-keys --keyserver \
 hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
 add-apt-repository \
 'deb http://mariadb.uberglobalmirror.com/repo/10.0/ubuntu utopic main' && \
 apt-get -q update && apt-get -qy upgrade && \
 apt-get -qy --no-install-recommends install \
 rsync mariadb-galera-server galera-arbitrator-3

COPY my.cnf /etc/mysql/

COMMAND /usr/bin/mysqldb
EXPOSE 3306 4444 4567 4568
