# linux 一键安装脚本 #


- 一键更换yum国内源

1. wget -qO- 12345bt.github.io/yum.sh && sh yum.sh

- 一键检测服务器配置、IO、下载速度

1. wget -qO- 12345bt.github.io/cesu.sh && sh cesu.sh

- 一键开启bbr加速

1. wget --no-check-certificate 12345bt.github.io/bbr.sh
2. chmod +x bbr.sh
3. ./bbr.sh


- 一键更新pip库   pip-review使用方法

1. pip install pip-review

2. pip-review --local --interactive


# 鸣谢 #
- [12345bt](http://www.github.com/12345bt "12345bt")
