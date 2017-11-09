#!/bin/sh

#一键更换中科院yum源
cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo.backup
mv epel.repo epel.repo.backup
mv epel-testing.repo epel-testing.repo.backup
wget 12345bt.github.io/CentOS-Base.repo
wget 12345bt.github.io/epel.repo
yum clean metadata
yum makecache
yum -y update
