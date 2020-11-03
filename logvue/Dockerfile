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

FROM debian:stretch
MAINTAINER Liang Chen "liangchenomc@gmail.com"

RUN DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing && apt-get install -y apt-utils

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    coreutils file less mg procps psmisc \
    dnsutils net-tools curl wget ca-certificates

RUN DEBIAN_FRONTEND=noninteractive apt-get clean

ENV U_HOME=/home/logvue

RUN mkdir -p $U_HOME
ADD ./etc $U_HOME/etc

ARG IMG_UID=1000

RUN bash $U_HOME/etc/preconf.sh

USER $IMG_UID
WORKDIR $U_HOME

CMD $U_HOME/etc/run.sh
