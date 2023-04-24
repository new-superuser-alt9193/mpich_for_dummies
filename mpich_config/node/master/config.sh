#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster Steps 2-3, 5-10

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="nfs-server openssh-server keychain build-essential mpich"
# //////////////////////////////

# Install dependencies
UpdateInstall $DEPS

# Step 1: Defining hostnames in etc/hosts/
SetHosts

# Step 3: Sharing Master Folder
mkdirMirror
echo "/mirror *(rw,sync)" | tee -a /etc/exports
service nfs-kernel-server restart   

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
setNewUser

# Step 7: Setting up passwordless SSH for communication between nodes (Not all the step)

su mpiu -c "
    ssh-keygen -t rsa -f \"$HOME_NEW_USER/.ssh/${ID_NEW_USER}_rsa\" -P \"\";
    cd $HOME_NEW_USER/.ssh;
    cat ${ID_NEW_USER}_rsa.pub >> authorized_keys
"