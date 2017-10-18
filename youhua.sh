#!/bin/bash
#author junxi by 
#this script is only for CentOS 7.x
#check the OS

platform=`uname -i`
if [ $platform != "x86_64" ];then 
echo "this script is only for 64bit Operating System !"
exit 1
fi
echo "the platform is ok"
cat << EOF
+---------------------------------------+
|   your system is CentOS 7 x86_64      |
|      start optimizing.......          |
+---------------------------------------
EOF

#添加公网DNS地址
cat >> /etc/resolv.conf << EOF
nameserver 114.114.114.114
EOF
#Yum源更换为国内阿里源
yum install wget telnet -y
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#添加阿里的epel源
#add the epel
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# rpm -ivh http://dl.Fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm

#yum重新建立缓存
yum clean all
yum makecache

#同步时间
yum -y install ntp
/usr/sbin/ntpdate cn.pool.ntp.org
echo "* 4 * * * /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
systemctl  restart crond.service

#yum安装常用库
yum install -y gcc gcc-c++ vim unzip zip git
yum install -y iostat sysstat

#设置最大打开文件描述符数
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*           soft   nofile       655350
*           hard   nofile       655350
EOF

#禁用selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

#关闭防火墙
systemctl disable firewalld.service 
systemctl stop firewalld.service 

#set ssh
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl  restart sshd.service

#禁用IP6
echo "alias net -pf -10 off" >> /etc/modprobe.conf
echo "alias ipv6 off" >> /etc/modprobe.conf
echo "install ipv6 /bin/true" >> /etc/modprobe.conf
echo "IPV6INIT=no" >> /etc/sysconfig/network
sed -i 's@ NETWORKING_IPV6=yes@ NETWORKING_IPV6=no@' /etc/sysconfig/network
chkconfig ip6tables off

#内核参数优化
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1
net.ipv4.ip_local_port_range = 1024 65536
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_abort_on_overflow = 0
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.netfilter.ip_conntrack_max = 2097152
net.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
EOF
/sbin/sysctl -p

#vim定义退格键可删除最后一个字符类型
echo 'alias vi=vim' >> /etc/profile
echo 'stty erase ^H' >> /etc/profile
cat >> /root/.vimrc << EOF
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
"set number
EOF

#关闭chkconfig服务
chkconfig bluetooth off
chkconfig sendmail off
chkconfig kudzu off
chkconfig nfslock off
chkconfig portmap off
chkconfig iptables off
chkconfig autofs off
chkconfig yum-updatesd off

#更新软件
yum -y update

cat << EOF
+-------------------------------------------------+
|                linux一键优化结束                 |
|   it's recommond to restart this server !       |
+-------------------------------------------------+
EOF

#重启服务器
shutdown -r now
