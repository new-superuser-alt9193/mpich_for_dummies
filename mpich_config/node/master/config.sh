#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster Steps 2-3, 5-10

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="nfs-server openssh-server keychain build-essential mpich"
# //////////////////////////////

# Install dependencies
# apt update
# apt install -y $DEPS

# Add hosts
for i in "${HOSTS[@]}"
do
   echo "$i" >> /etc/hosts
done

# Step 3: Sharing Master Folder
if [ -d /mirror ]; then
    rm -r /mirror
fi

mkdir /mirror
echo "/mirror *(rw,sync)" | tee -a /etc/exports
service nfs-kernel-server restart   

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
if id $NAME_NEW_USER &>/dev/null; then
    userdel $NAME_NEW_USER
fi

useradd -s /usr/bin/bash -m -d $HOME_NEW_USER -u $ID_NEW_USER $NAME_NEW_USER
passwd -d mpiu

# Step 7: Setting up passwordless SSH for communication between nodes (Not all the step)

su mpiu -c "
    ssh-keygen -t rsa -f \"$HOME_NEW_USER/.ssh/${ID_NEW_USER}_rsa\" -P \"\";
    cd $HOME_NEW_USER/.ssh;
    cat ${ID_NEW_USER}_rsa.pub >> authorized_keys
"