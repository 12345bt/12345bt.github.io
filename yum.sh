#!/bin/sh

#更换国内Dns
echo -e "nameserver 114.114.114.114\nnameserver 8.8.8.8" >> /etc/resolv.conf
#一键更换中科院yum源
cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo.bk
wget https://12345bt.github.io/centos/CentOS-Base.repo
wget -qO /etc/yum.repos.d/epel.repo https://12345bt.github.io/centos/epel-7.repo
yum clean metadata
yum makecache
