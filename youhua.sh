#!/bin/bash

#添加公网DNS地址
cat >> /etc/resolv.conf << EOF
nameserver 114.114.114.114
EOF

#Yum源更换为国内阿里源
yum -y install wget telnet
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache

#导入密钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#添加库
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
#更新内核
yum install -y yum-plugin-fastestmirror
yum --enablerepo=elrepo-kernel -y install kernel-ml

#yum安装常用库
yum install -y gcc gcc-c++ vim unzip zip git
yum install -y iostat sysstat

#内核参数优化
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.netfilter.ip_conntrack_max = 2097152
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_wmem = 8192 131072 16777216
net.ipv4.tcp_rmem = 32768 131072 16777216
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.core.somaxconn = 262144
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=180
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
sysctl -p

#重启服务器
shutdown -r now
