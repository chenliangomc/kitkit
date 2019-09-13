#
# ~/etc/dot.bashrc
#

if [ -f /etc/skel/.bashrc ]; then
   . /etc/skel/.bashrc
fi

if [ -d $HOME/bin ]; then
    PATH="$HOME/bin:$PATH"
fi

alias ll='ls -lAF'

