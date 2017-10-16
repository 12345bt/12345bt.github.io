#!/bin/sh

#更换国内Dns
echo -e "nameserver 114.114.114.114\nnameserver 8.8.8.8" >> /etc/resolv.conf
#一键更换中科院yum源
cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo.backup
mv epel.repo epel.repo.backup
mv epel-testing.repo epel-testing.repo.backup
wget 12345bt.github.io/CentOS-Base.repo
wget 12345bt.github.io/epel.repo
yum clean metadata
yum makecache
