#!/usr/bin/env bash

# download admin key and config files
# example cmd
# wget http://localhost:8080/uploads/adminkeys/ad6639b2-895c-4f49-9985-60e03dca3797.json -O aaa.json

# CENTERURL=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'` 

# data format # 
# [
#     {"public":"/home/lee/uploads/adminkeys/cc0b8c8c-88a2-4d78-995d-1642d5f72449.pem","filename":"ttkey_public_key.pem"},
#     {"private":"/home/lee/uploads/adminkeys/76f7d0f7-c16a-4cca-b2cf-60ebe11ec709.pem","filename":"ttkey_private_key.pem"},
#     {"adminconfig":"/home/lee/uploads/adminkeys/f95581cf-4ada-47bd-82b5-97084f03c7ee.json","filename":"hamonize.json"}
# ]

## test server
CENTERURL="192.168.0.210:8080"
USER=$(whoami)

echo "user..? $USER"
echo "PWD..? $PWD"

PUBLIC_KEY_PATH=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[0] | .public'`
PUBLIC_KEY_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[0] | .filename'`

echo "PUBLIC_KEY_PATH..? $PUBLIC_KEY_PATH"
echo "PUBLIC_KEY_NAME..? $PUBLIC_KEY_NAME"

PRIVATE_KEY_PATH=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[1] | .private'`
PRIVATE_KEY_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[1] | .filename'`

echo "PRIVATE_KEY_PATH..? $PRIVATE_KEY_PATH"
echo "PRIVATE_KEY_NAME..? $PRIVATE_KEY_NAME"

CONFIG_PATH=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[2] | .adminconfig'`
CONFIG_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[2] | .filename'`
 

echo "CONFIG_PATH..? $CONFIG_PATH"
echo "CONFIG_NAME..? $CONFIG_NAME"

sleep 2

## download files
if [ $PUBLIC_KEY_PATH != null ]; then
    wget http://$CENTERURL$PUBLIC_KEY_PATH -O $PUBLIC_KEY_NAME -P $PWD
fi

if [ $PRIVATE_KEY_PATH != null ]; then
    wget http://$CENTERURL$PRIVATE_KEY_PATH -O $PRIVATE_KEY_NAME -P $PWD
fi

if [ $CONFIG_PATH != null ]; then
    wget http://$CENTERURL$CONFIG_PATH -O $CONFIG_NAME -P $PWD
fi


FIND_RET_PUBLIC=`find . -name $PUBLIC_KEY_NAME`
FIND_RET_PRIVATE=`find . -name $PRIVATE_KEY_NAME`
FIND_RET_CONFIG=`find . -name $CONFIG_NAME`

echo "FIND_RET_PUBLIC : $FIND_RET_PUBLIC"
echo "FIND_RET_PRIVATE : $FIND_RET_PRIVATE"
echo "FIND_RET_PRIVATE : $FIND_RET_CONFIG"

ISEXIST=`sudo hamonize-cli authkeys list`
echo "ISEXIST : $ISEXIST"

## hamonize_admin_user_key 등록
if [ "$FIND_RET_PUBLIC" != null ] && [ "$FIND_RET_PRIVATE" != null ] && [ "$FIND_RET_CONFIG" != null ]; then
    echo "튜르"
    if [ "$ISEXIST" != null ]; then
        echo "튜르튜르"
    
        sudo hamonize-cli authkeys import hamonize-key/public $PWD/$PUBLIC_KEY_NAME
        sudo hamonize-cli authkeys import hamonize-key/private $PWD/$PRIVATE_KEY_NAME
        sudo hamonize-cli authkeys setaccessgroup hamonize-key/public $USER
        sudo hamonize-cli authkeys setaccessgroup hamonize-key/private $USER
    fi
    sudo hamonize-cli authkeys list
    
else    
    echo "뽈스"
fi

