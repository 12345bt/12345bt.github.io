#!/bin/bash
#  自用一键cc 安装脚本   使用方法 
#  webbench -c 5000 -t 120  http://www.baidu.com/

yum install -y gcc gcc-c++ git
wget -c --no-check-certificate https://raw.githubusercontent.com/12345bt/12345bt.github.io/master/webbench-1.5.tar.gz && tar zxvf webbench-1.5.tar.gz && rm -rf webbench-1.5.tar.gz && cd webbench-1.5
make
make install 
