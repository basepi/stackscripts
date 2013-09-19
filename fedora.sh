#!/bin/bash

exec &> /root/stackscript.log

SSHKEYURL=http://files.basepi.net/ssh_keys/cmyers-alice.pub

mkdir /root/.ssh/
touch /root/.ssh/authorized_keys
wget $SSHKEYURL --output-document=/tmp/cmyers-ssh.pub
cat /tmp/cmyers-ssh.pub >> /root/.ssh/authorized_keys

yum update -y
yum install -y zsh python python3 git
yum install -y vim

cd /root
git clone git://github.com/basepi/dotfiles
cd dotfiles
git submodule init
git submodule update
./install.py -y
chsh -s /bin/zsh root
cd /
