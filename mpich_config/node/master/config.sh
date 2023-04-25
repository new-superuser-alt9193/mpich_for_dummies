#!/bin/bash
# Script created by Fernando Jimenez Pereyra based on https://help.ubuntu.com/community/MpichCluster Steps 2-3, 5-10

# This script have to be run with sudo.

# //////////////////////////////
# Script config
source ../../commons/config.sh

DEPS="nfs-server openssh-server keychain build-essential mpich"
# //////////////////////////////
OPTS="\n
    Use one or more flags to run the script:\n
    -i\tInstall dependencies\n
    -h\tHosts setup\n
    -m\tCreate mirror directory\n
    -u\tSet new user\n
    -a\tDo all\n"
OPT_INSTALL=false
OPT_HOSTS=false
OPT_MIRROR=false
OPT_USER=false

if [ $# -eq 0 ]
then
    echo -e $OPTS
    exit 1
fi

while getopts "ihmua" opt;
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

# Step 3: Sharing Master Folder
if $OPT_MIRROR
then
    mkdirMirror
    echo "/mirror *(rw,sync)" | tee -a /etc/exports
    service nfs-kernel-server restart   
fi

# Step 5: Defining a user for running MPI programs
# If user exist delete it.
if $OPT_USER
then
    setNewUser

# Step 7: Setting up passwordless SSH for communication between nodes (Not all the step)

    su $NAME_NEW_USER -c "
        ssh-keygen -t rsa -f \"$HOME_NEW_USER/.ssh/${ID_NEW_USER}_rsa\" -P \"\";
        cd $HOME_NEW_USER/.ssh;
        cat ${ID_NEW_USER}_rsa.pub >> authorized_keys
    "
fi