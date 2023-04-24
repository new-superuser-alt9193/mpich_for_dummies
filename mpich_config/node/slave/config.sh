#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="openssh-server keychain build-essential mpich"
# //////////////////////////////

# Install dependencies
UpdateInstall $DEPS

# Step 1: Defining hostnames in etc/hosts/
SetHosts

# Step 4: Mounting /master in nodes
mkdirMirror
mount ub0:/mirror /mirror

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
setNewUser

