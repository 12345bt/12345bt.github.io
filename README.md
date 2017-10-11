# centos

傻瓜式一键替换yum源,5条命令 分5次在ssh里面输入


mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

cd /etc/yum.repos.d/

wget https://12345bt.github.io/centos/CentOS-Base.repo

yum clean all

yum makecache
