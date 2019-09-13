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

set +e

HOME=${HOME:-"/home/logvue"}
export HOME

if [ -f ${HOME}/etc/dot.bashrc ]; then
    cp ${HOME}/etc/dot.bashrc ${HOME}/.bashrc
fi

#--prepare-dir--#
mkdir -p ${HOME}/data/{elastic,mongo,graylog}

#--write-conf--#
echo "[ii] update config file"
if [ -v LOGVUE_URL ]; then
    FINAL_URL=${LOGVUE_URL:-"https://logvue.example.com/"}
    sed --in-place "s|\$url|${FINAL_URL}|g" ${HOME}/etc/graylog.conf
else
    sed --in-place "s|^http_external_uri|#http_external_uri|g" ${HOME}/etc/graylog.conf
fi
sed --in-place "s|\$home|${HOME}|g" ${HOME}/etc/graylog.conf

#--start-daemon--#
echo "[ii] start daemon"
supervisord -c ${HOME}/etc/supervisord.conf

echo "[ww] failsafe"
while true; do
    sleep 30
done
