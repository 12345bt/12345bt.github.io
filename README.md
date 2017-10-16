# centos

# 一键更换yum国内源

wget -qO- 12345bt.github.io/yum.sh | bash

# 一键检测服务器配置、IO、下载速度

wget -qO- 12345bt.github.io/cesu.sh | bash

# 一键开启bbr加速

wget --no-check-certificate 12345bt.github.io/bbr.sh

chmod +x bbr.sh

./bbr.sh

# 一键更新pip库   pip-review使用方法

pip install pip-review

pip-review --local --interactive

