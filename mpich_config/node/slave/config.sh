#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster

# This script have to be run with sudo.

# //////////////////////////////
# Script config

DEPS="openssh-server keychain build-essential mpich"

NAME_NEW_USER="mpiu"
ID_NEW_USER=1500

# //////////////////////////////

# Install dependencies
apt update
apt install -y $DEPS

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

useradd -s /usr/bin/bash -m -d /mirror/${NAME_NEW_USER} -u $ID_NEW_USER $NAME_NEW_USER
passwd -d mpiu

