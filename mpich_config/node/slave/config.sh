#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="nfs-client openssh-server keychain build-essential mpich"
# //////////////////////////////
OPTS="\n
    Use one or more flags to run the script:\n
    -i\tInstall dependencies\n
    -h\tHosts setup\n
    -m\tMount mirror directory\n
    -u\tSet new user\n
    -s\tEnable SSH with password authentication and permit empty password, not included in \"Do all\"\n
    -a\tDo all\n"
OPT_INSTALL=false
OPT_HOSTS=false
OPT_MIRROR=false
OPT_USER=false
OPT_SSH=false

if [ $# -eq 0 ]
then
    echo -e $OPTS
    exit 1
fi

while getopts "ihmuas" opt;
do
    case ${opt} in
        i )
            OPT_INSTALL=true
        ;;

        h)
            OPT_HOSTS=true
        ;;

        m )
            OPT_MIRROR=true
        ;;

        u )
            OPT_USER=true
        ;;

        a )
            OPT_INSTALL=true
            OPT_HOSTS=true
            OPT_MIRROR=true
            OPT_USER=true
        ;;
        
        s )
            OPT_SSH=true
        ;;

        * )
            echo -e $OPTS
            exit 1
        ;;
    esac
done

# Install dependencies
if $OPT_INSTALL
then
    UpdateInstall $DEPS
fi

# Step 1: Defining hostnames in etc/hosts/
if $OPT_HOSTS
then
    SetHosts
fi

# Step 4: Mounting /master in nodes
if $OPT_MIRROR
then
    mkdirMirror
    mount ub0:/mirror /mirror
fi

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
if $OPT_USER
then
    setNewUser
fi

if $OPT_SSH
then
    setSSH
fi