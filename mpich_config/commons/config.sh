#!/bin/bash

# User config
NAME_NEW_USER="mpiu"
ID_NEW_USER=1500
HOME_NEW_USER=/mirror/${NAME_NEW_USER}

# Hosts config
# IP HOSTNAME
HOSTS=(
    "192.168.4.9 ub0"
    "192.168.4.7 ub1"
    "192.168.4.8 ub2"
)
HOSTS_FILE=/etc/hosts