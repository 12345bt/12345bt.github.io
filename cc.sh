#!/usr/bin/env bash

wget -c --no-check-certificate https://raw.githubusercontent.com/12345bt/12345bt.github.io/master/webbench-1.5.tar.gz && tar zxvf webbench-1.5.tar.gz && rm -rf webbench-1.5.tar.gz && cd webbench-1.5 && make && make install
