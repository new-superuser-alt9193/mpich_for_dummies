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
for i in "${HOSTS[@]}"
do
   echo "$i" >> /etc/hosts
done

# Step 4: Mounting /master in nodes
if [ -d /mirror ]; then
    rm -r /mirror
fi

mkdir /mirror
# mount ub0:/mirror /mirror  

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
if id $NAME_NEW_USER &>/dev/null; then
    userdel $NAME_NEW_USER
fi

useradd -s /usr/bin/bash -m -d $HOME_NEW_USER -u $ID_NEW_USER $NAME_NEW_USER
passwd -d mpiu

