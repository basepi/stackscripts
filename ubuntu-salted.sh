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
apt-get upgrade -y
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
echo deb http://ppa.launchpad.net/saltstack/salt/ubuntu `lsb_release -sc` main | tee /etc/apt/sources.list.d/saltstack.list
wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | apt-key add -
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install salt-minion salt-master salt-syndic
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install zsh python python3 git
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install vim

cd /root
git clone git://github.com/basepi/dotfiles
cd dotfiles
git submodule init
git submodule update
./install.py -y
chsh -s /bin/zsh root
cd /
