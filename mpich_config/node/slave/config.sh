#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="openssh-server keychain build-essential mpich"
# //////////////////////////////

# Install dependencies
apt update
apt install -y $DEPS

# Step 1: Defining hostnames in etc/hosts/
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

# Step 4: Mounting /master in nodes
if [ -d /mirror ]; then
    rm -r /mirror
fi

mkdir /mirror
mount ub0:/mirror /mirror

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
if id $NAME_NEW_USER &>/dev/null; then
    userdel $NAME_NEW_USER
fi

useradd -s /usr/bin/bash -m -d $HOME_NEW_USER -u $ID_NEW_USER $NAME_NEW_USER
passwd -d mpiu

