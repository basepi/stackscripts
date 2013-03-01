#!/bin/bash

exec &> /root/stackscript.log

SSHKEYURL=http://files.basepi.net/ssh_keys/cmyers-alice.pub

export UCF_FORCE_CONFFOLD=YES
export DEBIAN_FRONTEND=noninteractive

mkdir /root/.ssh/
touch /root/.ssh/authorized_keys
wget $SSHKEYURL --output-document=/tmp/cmyers-ssh.pub
cat /tmp/cmyers-ssh.pub >> /root/.ssh/authorized_keys

apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

for i in salt-{common,master,minion,syndic,doc} sysvinit-utils; do
echo "Package: $i"
echo "Pin: release a=squeeze-backports"
echo "Pin-Priority: 600"
echo
done > /etc/apt/preferences.d/local-salt-backport.pref

cat <<_eof > /etc/apt/sources.list.d/local-madduck-backports.list
    deb http://debian.madduck.net/repo squeeze-backports main
    deb-src http://debian.madduck.net/repo squeeze-backports main
_eof

wget -q -O- "http://debian.madduck.net/repo/gpg/archive.key" | apt-key add -

apt-get update -y

apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install salt-minion salt-master salt-syndic
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install zsh git sudo mercurial gcc make python3 libncurses-dev

cd /root

wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar -xzvf Python-2.7.3.tgz
cd Python-2.7.3
./configure
make
make install
cd ..

export PATH=/usr/local/bin:$PATH

hg clone https://vim.googlecode.com/hg/ vim
cd vim
./configure --with-features=huge --enable-pythoninterp --with-python-config-dir=/usr/local/lib/python2.7/config
make
make install
cd ..

git clone git://github.com/basepi/dotfiles
cd dotfiles
git submodule init
git submodule update
./install.py -y
chsh -s /bin/zsh root

cd /
