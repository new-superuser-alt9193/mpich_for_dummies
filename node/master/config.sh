#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster

# This script have to be run with sudo.

# //////////////////////////////
# Script config

DEPS="nfs-server openssh-server keychain build-essential mpich"

NAME_NEW_USER="mpiu"
ID_NEW_USER=1500

# //////////////////////////////

# Install dependencies
apt install -y $DEPS

# Step 3: Sharing Master Folder

mkdir /mirror
echo "/mirror *(rw,sync)" | tee -a /etc/exports
service nfs-kernel-server restart   

# Step 5: Defining a user for running MPI programs
useradd -s /usr/bin/bash -m -d /mirror/${NAME_NEW_USER} -u $ID_NEW_USER $NAME_NEW_USER
passwd -d mpiu

# Step 7: Setting up passwordless SSH for communication between nodes (Not all the step)

su - mpiu
ssh-keygen -t rsa -f "~/.ssh/${ID_NEW_USER}_rsa"
cd .ssh
cat ${ID_NEW_USER}_rsa.pub >> authorized_keys
exit