FROM ubuntu:17.04
MAINTAINER Betacloud Solutions GmbH (https://www.betacloud-solutions.de)

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION ${VERSION:-2.8}

# NOTE: the release28 branch contains bugfixes for the 2.8 series not yet released
ENV BRANCH ${BRANCH:-release28}

COPY files/extend_start.sh /extend_start.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apache2 \
        atftpd \
        git \
        isc-dhcp-server \
        libapache2-mod-wsgi \
        lsb-release \
        make \
        python-cheetah \
        python-django \
        python-netaddr \
        python-simplejson \
        python-urlgrabber \
        python-yaml \
        syslinux \
        xinetd \
    && a2enmod proxy \
    && a2enmod proxy_http


RUN git clone -b $BRANCH https://github.com/cobbler/cobbler /cobbler-repository \
    && cd /cobbler-repository \
    && make install \
    && cp -r /var/lib/cobbler /var/lib/cobbler.docker \
    && rm -rf /var/lib/cobbler/* \
    && cp -r /srv/www/cobbler /srv/www/cobbler.docker \
    && rm -rf /srv/www/cobbler/* \
    && ln -s /etc/apache2/conf-available/cobbler.conf /etc/apache2/conf-enabled/cobbler.conf \
    && ln -s /etc/apache2/conf-available/cobbler_web.conf /etc/apache2/conf-enabled/cobbler_web.conf \
    && ln -s /var/lib/cobbler/loaders/menu.c32 /usr/lib/syslinux/menu.c32 \
    && ln -s /var/lib/cobbler/loaders/pxelinux.0 /usr/lib/syslinux/pxelinux.0

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /cobbler-repository

CMD ["/extend_start.sh"]
