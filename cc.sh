#!/usr/bin/env bash
#  自用一键cc 安装脚本   使用方法 
#  webbench -c 5000 -t 120  http://www.baidu.com/

yum install -y gcc gcc-c++ git
wget https://12345bt.github.io/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make && make install