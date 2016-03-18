#!/bin/bash
# -------------------------------
# Date:        2016-03-18
# ------------------------------- 

# 要同步的源
YUM_SITE="rsync://mirrors.kernel.org/centos/"

# 本地存放目录
LOCAL_PATH="/u01/CentOS/"

# 需要同步的版本，我只需要6和7版本的
LOCAL_VER="6 6* 7 7*"

# 记录本脚本进程号
LOCK_FILE="/var/log/yum_server.pid"

# 如用系统默认rsync工具为空即可。
# 如用自己安装的rsync工具直接填写完整路径
RSYNC_PATH=""

# 设置锁文件
MY_PID=$$
if [ -f $LOCK_FILE ]; then
    get_pid=`/bin/cat $LOCK_FILE`
    get_system_pid=`/bin/ps -ef|grep -v grep|grep $get_pid|wc -l`
    if [ $get_system_pid -eq 0 ] ; then
        echo $MY_PID>$LOCK_FILE
    else
        echo "$LOCK_FILE already exists!"
        exit 1
    fi
else
    echo $MY_PID>$LOCK_FILE
fi
 
# 检查rsync是否存在
if [ -z $RSYNC_PATH ]; then
    RSYNC_PATH=`/usr/bin/whereis rsync|awk ' ''{print $2}'`
    if [ -z $RSYNC_PATH ]; then
        echo 'Not find rsync'
        echo 'use cmd: yum install -y rsync'
    fi
fi
 
# 同步yum源
for VER in $LOCAL_VER;
do 
    # 检测本地目录是够存在
    if [ ! -d "$LOCAL_PATH$VER" ] ; then
        echo "Create dir $LOCAL_PATH$VER"
        `/bin/mkdir -p $LOCAL_PATH$VER`
    fi
    # 开始同步
    echo "Start sync $LOCAL_PATH$VER"
    $RSYNC_PATH -avrtH --delete --exclude "isos" $YUM_SITE$VER $LOCAL_PATH$VER
done
 
# 删除锁文件
`/bin/rm -rf $LOCK_FILE`
 
echo 'sync end.'
