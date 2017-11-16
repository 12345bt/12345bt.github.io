#!/bin/sh
#傻瓜式一键安装 webbench 神器

#安装必备技能
yum -y install git gcc ctags

#git克隆webbench
git clone https://github.com/12345bt/webbench.git

#防止出错 提前创建文件夹
mkdir -m 777 -p /usr/local/man/man1

#克隆ok 进入项目文件夹
cd webbench

#安装
make && make install
