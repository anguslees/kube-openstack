FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

ENV \
 PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin \
 PREFIX=/home/install \
 ETC_IN=/home/install/etc \
 ETC=/home/user/etc \
 BRANCH=stable/liberty

# Run pip install as one (non-root) user, and run resulting binaries
# as another.
RUN \
 apt-get -q update && apt-get -qy upgrade && \
 adduser --disabled-login --gecos 'Unprivileged runtime user' user && \
 adduser --disabled-login --gecos 'Unprivileged install user' install && \
 apt-get -qy --no-install-recommends install \
 sudo virtualenv python-dev python-pip git build-essential

# System depdendencies needed to build python modules, followed by runtime deps.
#
# Note!
# rootwrap.conf controls sudo/rootwrap access and in a secure setup needs to
# be installed from a trusted source to a location writeable only by
# root.  In the interests of easy testing of git HEAD, that is not
# what we're doing here.
#
RUN \
 set -x && \
 apt-get -qy --no-install-recommends install \
 libxslt-dev libxml2-dev zlib1g-dev libyaml-dev libffi-dev libssl-dev \
 rsync && \
 mkdir -p /etc/swift /var/lib/swift /var/lock/swift && \
 chown user:user /var/lib/swift /var/lock/swift

# _wrap.sh sets up environment and copies templated configs from $ETC_IN -> $ETC
COPY _wrap.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/_wrap.sh"]
CMD ["/bin/bash"]

USER install
RUN \
 set -x && \
 cd $PREFIX && \
 git clone --depth 1 --single-branch --branch $BRANCH https://github.com/openstack/swift.git git-fetch && \
 cd git-fetch && \
 virtualenv --system-site-packages $PREFIX/venv && \
 $PREFIX/venv/bin/pip install --upgrade --compile 'pip>=6' && \
 $PREFIX/venv/bin/pip install --compile 'pbr>=1.3' && \
 $PREFIX/venv/bin/pip install --compile . PyMySQL && \
 mkdir -p $ETC_IN && \
 cp -r etc $ETC_IN/swift && \
 . $PREFIX/venv/bin/activate && swift-proxy-server --help

COPY swift.conf.in object-server.conf.in container-server.conf.in account-server.conf.in proxy-server.conf.in /etc/swift/

USER user
WORKDIR /
VOLUME ["/srv/node"]
EXPOSE 80 6000 6001 6002
