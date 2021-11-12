#!/usr/bin/env bash
DIR_PATH="$(pwd)"
DIR_NAME=${PWD##*/}
VOL_NAME=$DIR_NAME"_reprepro-data"

## If you don't have ssh key then, use this option
if [ "$1" = "--gen-ssh-key" ]; then
    echo "generating ssh key start..."
    cd ~/.ssh
    ssh-keygen -b 2048 -t rsa -f ssh_host_rsa_key -q -N ""
    cp ssh_host_* $DIR_PATH/repo/ssh/
    cd $DIR_PATH/repo/ssh/
    cp ssh_host_rsa_key.pub authorized_keys
    cd ../..
    echo "generating ssh key end..."

fi

## docker execute
docker-compose up -d

## change ssh public key
docker cp repo/ apt:/
sudo sh -c "cat $(pwd)/repo/ssh/ssh_host_rsa_key.pub > /var/lib/docker/volumes/$VOL_NAME/_data/ssh/authorized_keys"
docker-compose exec apt bash -c "chmod 600 /repo/ssh/*key; chmod 644 /repo/ssh/*.pub; chmod 600 /repo/ssh/authorized_keys" 
docker-compose exec apt bash -c "chown root:root repo/; chown root:root repo/ssh/; chown root:root repo/ssh/*;"

## add apt gpg key && repo
wget -qO - http://localhost:8088/hamonize.pubkey.gpg | sudo apt-key add -
echo "deb [arch=amd64] http://localhost:8088 hamonize main" | sudo tee /etc/apt/sources.list.d/hamonize.list
sudo apt-get update 



