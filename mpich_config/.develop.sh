#!/bin/bash

# Hosts config
HOSTS=(
    192.168.4.10 ub0
    192.168.4.7 ub1
    192.168.4.8 ub2
)

HOSTS_FILE=test.txt

# for ((i = 0; i < ${#HOSTS[@]}; i += 2))
# do 
#     echo ${HOSTS[$i]} ${HOSTS[$((i+1))]}
# done

for ((i = 0; i < ${#HOSTS[@]}; i += 2))
do 
    IP=${HOSTS[$i]}
    HOSTNAME=${HOSTS[$((i+1))]}

    if grep -Fq $HOSTNAME $HOSTS_FILE
    then
        if grep -Fxq "$IP $HOSTNAME" $HOSTS_FILE
        then
            echo Hostname $HOSTNAME whit IP $IP exist in $HOSTS_FILE
        else
            echo Hostname $HOSTNAME exist in $HOSTS_FILE with another IP, changing IP to $IP
            sed -i "/$HOSTNAME/d" $HOSTS_FILE
            echo $IP $HOSTNAME >> $HOSTS_FILE
        fi
    else
        echo Hostname $HOSTNAME no exist in $HOSTS_FILE, adding $HOSTNAME to $HOSTS_FILE
        echo $IP $HOSTNAME >> $HOSTS_FILE
    fi
done