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

U_MAX=${U_MAX:-2000000000}
MU_HOME=${MU_HOME:-"/home/master"}

#-sys-config;
echo "export TERM=xterm" | tee -a /etc/profile > /dev/null
echo "export LANG=en_US.UTF-8" | tee -a /etc/profile > /dev/null

sed -i "s/UID_MAX/UID_MAX ${U_MAX}\\n#UID_MAX/g" /etc/login.defs
sed -i "s/GID_MAX/GID_MAX ${U_MAX}\\n#GID_MAX/g" /etc/login.defs

if [ -w /etc/resolv.conf ]; then
    echo "options randomize-case:0" >>  /etc/resolv.conf
fi

#-add-user;
TMPLST="/tmp/.userlist.txt"
rm -f $TMPLST && touch $TMPLST

echo "shinken:thepass:$IMG_UID:$IMG_UID:master,service:$MU_HOME:/bin/bash" >> $TMPLST
newusers $TMPLST
rm $TMPLST

cp /etc/skel/.bashrc $MU_HOME/.bashrc

#-add-pkg;
BACKPORT_CONF="$MU_HOME/etc/setup_apt_repo.sh"
if [ -f $BACKPORT_CONF ]; then
    bash $BACKPORT_CONF
fi

DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    apt-transport-https gnupg debian-archive-keyring \
    psmisc uuid-runtime openssh-client \
    stunnel4 logrotate supervisor

DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    python-dev python-pip python-pycurl

DEBIAN_FRONTEND=noninteractive apt-get install -q -y monitoring-plugins
DEBIAN_FRONTEND=noninteractive apt-get clean


pip install --upgrade pip setuptools
pip install bottle cherrypy passlib

TARBALL='master'
wget -c -O /tmp/${TARBALL}.tar.gz https://github.com/naparuba/shinken/archive/${TARBALL}.tar.gz
tar -xzf /tmp/${TARBALL}.tar.gz
cd shinken-${TARBALL}; python setup.py install

#-update-permission;
mkdir -p $MU_HOME/temp

chown -R $IMG_UID:$IMG_UID $MU_HOME

chmod 775 $MU_HOME $MU_HOME/etc $MU_HOME/temp
chmod a+x $MU_HOME/etc/*sh

#--final-clean-up--#
_sp=$(realpath $0)
rm -f $_sp

exit 0

#--eof--#
