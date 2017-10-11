# centos

傻瓜式一键替换yum源,5条命令 分5次在ssh里面输入


mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

wget -O /etc/yum.repos.d/CentOS-Base.repo https://12345bt.github.io/centos/CentOS-Base.repo

yum clean all

yum makecache

yum -y update



163源

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

wget -O /etc/yum.repos.d/CentOS-Base.repo https://12345bt.github.io/centos/CentOS7-Base-163.repo

yum clean all

yum makecache

yum -y update
