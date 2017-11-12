#!/bin/bash
#12345bt自用一键懒人脚本 centos7 64位系列
#其他系统使用 出现问题 概不负责

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

#yum安装常用库
yum install -y gcc gcc-c++ vim unzip zip git
yum install -y iostat sysstat

#导入密钥  添加库  更新4.1.3内核
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum install -y yum-plugin-fastestmirror
yum --enablerepo=elrepo-kernel install  kernel-ml-devel kernel-ml -y

#内核参数优化,配置开启BBR
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_tw_reuse = 1
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
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

#加载新配置
sysctl -p

#修改默认启动内核
grub2-set-default 0

#重启服务器
shutdown -r now
