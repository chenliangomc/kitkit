#!/bin/bash

#  Copyright 2018, 2019, 2020 Liang Chen <liangchenomc@gmail.com>
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

exec ${JAVA:=/usr/bin/java} -jar -Dlog4j.configurationFile=file://${HOME}/etc/log4j2.graylog.properties -Djava.library.path=/usr/share/graylog-server/lib/sigar /usr/share/graylog-server/graylog.jar server -f ${HOME}/etc/graylog.conf -np

