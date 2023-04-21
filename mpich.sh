sudo apt install nfs-server nfs-client openssh-server keychain build-essential mpich

sudo mkdir /mirror
echo "/mirror *(rw,sync)" | sudo tee -a /etc/exports
sudo service nfs-kernel-server restart
sudo exportfs -a

sudo userdel mpiu
sudo useradd -s /usr/bin/bash -m -d /mirror/mpiu mpiu
sudo passwd mpiu
sudo chown mpiu /mirror

su - mpiu
ssh-keygen -t rsa
mkdir .ssh
cd .ssh
cat mpiu_rsa.pub >> authorized_keys
