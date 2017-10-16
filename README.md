# centos

傻瓜式一键替换yum源,5条命令 分5次在ssh里面输入
    
wget --no-check-certificate 12345bt.github.io/yum.sh && sh yum.sh

一键检测服务器配置、IO、下载速度

wget -qO- 12345bt.github.io/cesu.sh && sh cesu.sh

pip --upgrade 批量更新过期的python库

查看系统里过期的python库，可以用pip命令

pip list

#列出所有安装的库

pip list --outdated

#列出所有过期的库


另外的也有人提到用 pip-review ，不想安装就没用

使用方法,也是非常傻瓜一键更新pip库

pip install pip-review    #安装pip-review

pip-review --local --interactive    #一键更新待更新的库,需要的按 Y 不需要的 N
