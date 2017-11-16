#!/usr/bin/env bash
# 一键检测服务器基本信息 IO性能,   纯中文显示，好歹咱是中国人，做点小贡献。
# 去除各种线路检测,，没吊用。还浪费时间。


if  [ ! -e '/usr/bin/wget' ]; then
    echo "Error: wget command not found. You must be install wget command at first."
    exit 1
fi
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-60s\n" "-" | sed 's/\s/-/g'
}

io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=$1 count=$2 conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )
uswap=$( free -m | awk '/Swap/ {print $3}' )
up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d 天 %d 小时 %d 分钟\n",a,b,c)}' /proc/uptime )
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )
ptime=$(power_time)

clear
next
echo -e "    发行版本     : ${YELLOW}$opsy${PLAIN}"
echo -e "    系统类型     : ${YELLOW}$arch ($lbit Bit)${PLAIN}"
echo -e "    内核版本     : ${YELLOW}$kern${PLAIN}"
echo -e "    CPU 型号     : ${YELLOW}$cname${PLAIN}"
echo -e "    CPU 核心     : ${YELLOW}$cores 颗${PLAIN}"
echo -e "    CPU 频率     : ${YELLOW}$freq MHz${PLAIN}"
echo -e "    硬盘大小     : ${YELLOW}$disk_total_size GB  已使用 $disk_used_size GB${PLAIN}"
echo -e "    内存大小     : ${YELLOW}$tram MB  已使用 $uram MB${PLAIN}"
echo -e "    交换空间     : ${YELLOW}$swap MB  已使用 $uswap MB${PLAIN}"
echo -e "    运行时间     : ${YELLOW}$up${PLAIN}"
echo -e "    当前负载     : ${YELLOW}$load${PLAIN}"
next
echo -n "    I/O 测 32M   : "
io1=$( io_test 32k 1k )
echo -e "${SKYBLUE}$io1${PLAIN}"
echo -n "    I/O 测 256M  : "
io2=$( io_test 64k 4k )
echo -e "${SKYBLUE}$io2${PLAIN}"
echo -n "    I/O 测 2G    : "
io3=$( io_test 64k 32k )
echo -e "${SKYBLUE}$io3${PLAIN}"
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
echo -e "    I/O 平均值   : ${SKYBLUE}$ioavg MB/s${PLAIN}"
next
