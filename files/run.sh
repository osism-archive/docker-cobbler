#!/usr/bin/env bash
set -x

# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

# Available environment variables
#
# n/a

if [[ ! -e /var/lib/cobbler/.bootstrapped ]]; then
    cp -r /var/lib/cobbler.docker/* /var/lib/cobbler
    touch /var/lib/cobbler/.bootstrapped
fi

if [[ ! -e /srv/www/cobbler/.bootstrapped ]]; then
    cp -r /srv/www/cobbler.docker/* /srv/www/cobbler
    touch /srv/www/cobbler/.bootstrapped
fi

rm -f /var/run/dhcpd.pid

apache2ctl start
service xinetd start
cobblerd --no-daemonize
