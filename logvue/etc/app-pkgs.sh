#!/bin/bash

#  Copyright 2018, 2019 Liang Chen <liangchenomc@gmail.com>
#
#  This file is part of kitkit.
#
#  kitkit is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Affero General Public License
#  as published by the Free Software Foundation, either version 3 of
#  the License, or (at your option) any later version.
#
#  kitkit is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with kitkit. If not, see <https://www.gnu.org/licenses/>.

set -e

#--rabbitmq--#
#DEBIAN_FRONTEND=noninteractive apt-get -q -y install erlang-nox rabbitmq-server
MQ_MGMT="/usr/sbin/rabbitmq-plugins"
if [ -x ${MQ_MGMT} ]; then
    ${MQ_MGMT} enable rabbitmq_management --offline
fi

#--elasticsearch--#
ES_PKG="elasticsearch-5.6.16.deb"

wget -c -nv -O /tmp/${ES_PKG} -- https://artifacts.elastic.co/downloads/elasticsearch/${ES_PKG}
dpkg -i /tmp/${ES_PKG}

#--graylog--#
# https://packages.graylog2.org/repo/packages/graylog-3.0-repository_latest.deb
#
# https://packages.graylog2.org/repo/debian/dists/stable/3.0/binary-amd64/Packages
# Package: graylog-server
# Version: 3.0.1-2
# Filename: pool/stable/3.0/g/graylog-server/graylog-server_3.0.1-2_all.deb
#
# https://packages.graylog2.org/repo/debian/pool/stable/3.0/g/graylog-integrations-plugins/graylog-integrations-plugins_3.0.1-2_all.deb
GL_PKG="graylog-server_3.0.1-2_all.deb"

wget -c -nv -O /tmp/${GL_PKG} -- https://packages.graylog2.org/repo/debian/pool/stable/3.0/g/graylog-server/${GL_PKG}
dpkg -i /tmp/${GL_PKG}

L_BIN="/usr/local/bin"
if [ ! -d ${L_BIN} ];then
    mkdir -p ${L_BIN}
fi
mv ${U_HOME}/etc/g.sh ${L_BIN}/graylog.sh
chmod a+x ${L_BIN}/graylog.sh

#--logstash--#
# TODO: add logstash installation script here;

#--clean-up--#
DEBIAN_FRONTEND=noninteractive apt-get clean
rm -f /tmp/${ES_PKG} /tmp/${GL_PKG}

exit 0
