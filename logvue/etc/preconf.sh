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
U_HOME=${U_HOME:-"/home/logvue"}
U_PASS=${U_PASS:-"the.password"}
export U_HOME

#--sys-config--#
echo "export TERM=xterm" | tee -a /etc/profile > /dev/null
echo "export LANG=en_US.UTF-8" | tee -a /etc/profile > /dev/null

sed -i "s/UID_MAX/UID_MAX ${U_MAX}\\n#UID_MAX/g" /etc/login.defs
sed -i "s/GID_MAX/GID_MAX ${U_MAX}\\n#GID_MAX/g" /etc/login.defs

if [ -w /etc/resolv.conf ]; then
    echo "options randomize-case:0" >>  /etc/resolv.conf
fi

#--user-account--#
TMPLST="/tmp/.userlist.txt"
rm -f $TMPLST && touch $TMPLST

echo "logvue:$U_PASS:$IMG_UID:$IMG_UID:log,viewer:$U_HOME:/bin/bash" >> $TMPLST
newusers $TMPLST
rm $TMPLST

#wc -l /etc/subuid /etc/subgid
cp /etc/skel/.bashrc $U_HOME/.bashrc

#--install-dependency--#
BACKPORT_CONF="$U_HOME/etc/setup_apt_repo.sh"
if [ -f $BACKPORT_CONF ]; then
    bash $BACKPORT_CONF
fi

DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    stunnel4 logrotate supervisor
DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    mongodb-server default-jre-headless uuid-runtime

#--app-environment--#
J_HOME=$(readlink -f /usr/bin/java | sed "s:/jre/bin/java::")
J_POLICY_PATH=${J_HOME}/jre/lib/security/java.policy
if [ -f ${J_POLICY_PATH} ]; then
    TCNT=$(wc -l ${J_POLICY_PATH} | awk '{print $1}')
    sed -i "$(($TCNT - 5))i  permission javax.management.MBeanTrustPermission \"register\";"  ${J_POLICY_PATH}
fi

#--app-install--#
APP_PKG_SH=${U_HOME}/etc/app-pkgs.sh
if [ -f $APP_PKG_SH ]; then
    bash $APP_PKG_SH
    #if [ $? -eq 0 ]; then
    #    echo "failed to install packages."
    #    exit 1
    #fi
    rm -f $APP_PKG_SH
fi

#--update-permission--#
mkdir -p $U_HOME/{temp,data,bin}
chown -R $IMG_UID:$IMG_UID $U_HOME

chmod 775 $U_HOME
chmod a+x $U_HOME/etc/*sh

#--final-clean-up--#
_sp=$(realpath $0)
rm -f $_sp

exit 0
