FROM ubuntu:17.04
MAINTAINER Betacloud Solutions GmbH (https://www.betacloud-solutions.de)

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION ${VERSION:-latest}

COPY files/extend_start.sh /extend_start.sh
COPY files/revert_lp898838.patch /revert_lp898838.patch

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        cobbler \
        cobbler-web \
        isc-dhcp-server \
        patch \
        xinetd \
    && patch -p1 < /revert_lp898838.patch \
    && rm /revert_lp898838.patch \
    && ln -s /var/lib/cobbler/loaders/menu.c32 /usr/lib/syslinux/menu.c32 \
    && ln -s /var/lib/cobbler/loaders/pxelinux.0 /usr/lib/syslinux/pxelinux.0 \
    && apt-get clean \
    && cp -r /var/lib/cobbler /var/lib/cobbler.docker \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/pxelocal.template /etc/cobbler/pxe/pxelocal.template

CMD ["/extend_start.sh"]
