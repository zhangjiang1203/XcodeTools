#!/bin/bash


# 输出所有参数
echo ${@}

echo "你好我好 大家好 哈哈哈啊"


pod_path=$1
option=$2

pod_bin=`find ~/.rvm/gems -depth 3 -name pod | grep bin`
echo $pod_bin

if [ $option == 'install' ]; then
    cd $pod_path
    $pod_bin install
fi

if [ $option == 'update' ]; then
    cd $pod_path
    $pod_bin update
fi
