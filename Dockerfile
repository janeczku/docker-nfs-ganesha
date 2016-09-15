FROM ubuntu:14.04
MAINTAINER Jan Bruder <jan@rancher.com>

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y wget unzip uuid-runtime python-setuptools udev runit sharutils nfs-common dbus && \
    # install ganesha
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FE869A9 && \
    echo "deb http://ppa.launchpad.net/gluster/nfs-ganesha/ubuntu trusty main" | tee /etc/apt/sources.list.d/nfs-ganesha.list && \
    echo "deb http://ppa.launchpad.net/gluster/libntirpc/ubuntu trusty main" | tee /etc/apt/sources.list.d/libntirpc.list && \
    apt-get update && apt-get install -y --force-yes nfs-ganesha nfs-ganesha-fsal && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prepare folders
RUN mkdir -p /run/rpcbind && touch /run/rpcbind/rpcbind.xdr && touch /run/rpcbind/portmap.xdr && chmod 777 /run/rpcbind/*  && \
    mkdir -p /export && \
    mkdir -p /var/run/dbus && chown messagebus:messagebus /var/run/dbus

# Add startup script and ganesha config
ADD start.sh /
ADD ganesha.conf /etc/ganesha/ganesha.conf

# NFS ports and portmapper
EXPOSE 2049 38465-38467 662 111/udp 111

# Start Ganesha NFS daemon by default
CMD ["/start.sh"]