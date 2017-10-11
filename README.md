# centos

傻瓜式一键替换yum源

第一种方法:  wget 下载安装

1、备份

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

2、下载新的CentOS-Base.repo 到/etc/yum.repos.d/

CentOS 7

wget -O /etc/yum.repos.d/CentOS-Base.repo https://raw.githubusercontent.com/12345bt/centos/master/CentOS-Base.repo

或者
curl -o /etc/yum.repos.d/CentOS-Base.repo https://raw.githubusercontent.com/12345bt/centos/master/CentOS-Base.repo

3、之后运行yum makecache生成缓存
