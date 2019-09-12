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


HOME=${MU_HOME:-"/home/master"}
export HOME


#-install-mods;
echo "[ii] install required mod"
shinken --init
shinken install webui2
shinken install auth-cfg-password
shinken install auth-htpasswd
shinken install auth-active-directory
#shinken install sqlitedb
echo "[ii] currently installed mod:"; shinken inventory

#-app-config;
sed -i "s/modules/modules webui2\n#/g" /etc/shinken/brokers/broker-master.cfg
rm -f /etc/shinken/receivers/*

if [ -d /opt/etc ]; then
    rsync -rlq /opt/etc/ ${HOME}/etc/ || true
fi

if [ -f ${HOME}/etc/mailrelay.sh ]; then
    bash ${HOME}/etc/mailrelay.sh
fi

if [ -f ${HOME}/etc/webui2.cfg ]; then
    rm -f /etc/shinken/modules/* ; cp -t /etc/shinken/modules/ ${HOME}/etc/webui2.cfg
fi
if [ -d ${HOME}/etc/cmd ]; then
    cp -t /etc/shinken/commands/ ${HOME}/etc/cmd/*.cfg
fi
if [ -f ${HOME}/etc/svcgrp.cfg ]; then
    cp -t /etc/shinken/servicegroups/ ${HOME}/etc/svcgrp.cfg
fi
if [ -d ${HOME}/etc/users ]; then
    rm -f /etc/shinken/contacts/* ; cp -t /etc/shinken/contacts/ ${HOME}/etc/users/*.cfg
fi
if [ -f ${HOME}/etc/hosts.cfg ]; then
    rm -f /etc/shinken/hosts/* ; cp -t /etc/shinken/hosts/ ${HOME}/etc/hosts.cfg
fi
if [ -f ${HOME}/etc/services.cfg ]; then
    rm -f /etc/shinken/services/* ; cp -t /etc/shinken/services/ ${HOME}/etc/services.cfg
fi

echo "[ii] verify configuration"
shinken-arbiter -v -c /etc/shinken/shinken.cfg


echo "[ii] start service(s)"
supervisord -c ${HOME}/etc/supervisord.conf

#-failsafe;
echo "[ww] failsafe"
while true; do
    sleep 30
done
