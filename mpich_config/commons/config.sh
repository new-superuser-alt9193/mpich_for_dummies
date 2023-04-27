#!/bin/bash

# User config
NAME_NEW_USER="mpiu"
ID_NEW_USER=1500
HOME_NEW_USER=/home/${NAME_NEW_USER}
PASSWORD_NEW_USER=123

# Hosts config
# IP HOSTNAME
HOSTS=(
    192.168.4.9 ub0
    192.168.4.7 ub1
    192.168.4.8 ub2
    192.168.4.100 ub3
)
HOSTS_FILE=/etc/hosts

#////////////////////////////////////////////////
UpdateInstall(){
    wget -q --spider http://google.com
    if [ $? -eq 0 ]
    then
        apt update
        apt install -y $@
    else
        echo "You need an internet connection to install the dependencies."
    fi
}

SetHosts(){
    for ((i = 0; i < ${#HOSTS[@]}; i += 2))
    do 
        IP=${HOSTS[$i]}
        HOSTNAME=${HOSTS[$((i+1))]}

        if grep -Fq $HOSTNAME $HOSTS_FILE
        then
            if grep -Fxq "$IP $HOSTNAME" $HOSTS_FILE
            then
                echo "Hostname $HOSTNAME whit IP $IP already exist in $HOSTS_FILE."
            else
                echo "Hostname $HOSTNAME already exist in $HOSTS_FILE with another IP, changing IP to $IP."
                sed -i "/$HOSTNAME/d" $HOSTS_FILE
                echo $IP $HOSTNAME >> $HOSTS_FILE
            fi
        else
            echo "Hostname $HOSTNAME no exist in $HOSTS_FILE, adding $HOSTNAME to $HOSTS_FILE."
            echo $IP $HOSTNAME >> $HOSTS_FILE
        fi
    done
}

mkdirMirror(){
    if [ -d /mirror ]
    then
        rm -r /mirror
    fi

    mkdir /mirror
}

setNewUser(){
    if id $NAME_NEW_USER &>/dev/null
    then
        userdel $NAME_NEW_USER
        rm -r $HOME_NEW_USER
    fi

    useradd -s /usr/bin/bash -m -d $HOME_NEW_USER -u $ID_NEW_USER $NAME_NEW_USER
    adduser $NAME_NEW_USER sudo
    echo -e "$PASSWORD_NEW_USER\n$PASSWORD_NEW_USER" | ( passwd $NAME_NEW_USER  > /dev/null 2>&1)
}

setSSH(){
    SSH_CONFIG=/etc/ssh/sshd_config
    sed -i '/#PasswordAuthentication yes/c\PasswordAuthentication yes' $SSH_CONFIG
    sed -i '/#PermitEmptyPasswords no/c\PermitEmptyPasswords yes' $SSH_CONFIG
}