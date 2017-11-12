# linux 一键安装脚本 #


- 一键更换yum国内源

1. wget -qO- 12345bt.github.io/yum.sh | bash

- 一键检测服务器配置、IO、下载速度

1. wget -qO- 12345bt.github.io/cesu.sh | bash

- 一键开启bbr加速

1. wget --no-check-certificate 12345bt.github.io/bbr.sh
2. chmod +x bbr.sh
3. ./bbr.sh


- 网站历史记录IP,绕过CDN,追查真实IP地址

1. http://www.viewdns.info/iphistory/?domain=www.vuln.cn
2. http://toolbar.netcraft.com/site_report?url=t00ls.net
3. https://www.domainiq.com/hosting_research
4. http://toolbar.netcraft.com/site_report?url=xxoo.xom
5. http://site.ip138.com/xxoo.xom

- 一键优化centos7 各项性能 更换yum源 开启bbr加速 

1. wget --no-check-certificate 12345bt.github.io/youhua.sh && chmod +x youhua.sh && ./youhua.sh

- 一键更新pip库   pip-review使用方法

1. pip install pip-review

2. pip-review --local --interactive

- 客户端一键安装酸酸乳命令：

1. wget -N --no-check-certificate https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/ss-panel-v3-mod.sh && chmod +x ss-panel-v3-mod.sh && bash ss-panel-v3-mod.sh


# 鸣谢 #
- [12345bt](http://www.github.com/12345bt "12345bt")
