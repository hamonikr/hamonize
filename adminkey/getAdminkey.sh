#!/bin/bash

# download admin key and config files
# example cmd
# wget http://localhost:8080/uploads/adminkeys/ad6639b2-895c-4f49-9985-60e03dca3797.json -O aaa.json

# CENTERURL=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'` 

# data format # 
# [
#     {"filename":"ttkey_public_key.pem","public":"/home/lee/uploads/adminkeys/cc0b8c8c-88a2-4d78-995d-1642d5f72449.pem"},
#     {"private":"/home/lee/uploads/adminkeys/76f7d0f7-c16a-4cca-b2cf-60ebe11ec709.pem","filename":"ttkey_private_key.pem"},
#     {"adminconfig":"/home/lee/uploads/adminkeys/f95581cf-4ada-47bd-82b5-97084f03c7ee.json","filename":"hamonize.json"}
# ]

## test server
CENTERURL="192.168.0.210:8081"
USER= whoami

echo "user..? $USER"
echo "PWD..? $PWD"

PUBLIC_KEY= `curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[0] | .public'`
PUBLIC_KEY_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[0] | .filename'`
sleep 2
echo "PUBLIC_KEY..? $PUBLIC_KEY"
echo "PUBLIC_KEY_NAME..? $PUBLIC_KEY_NAME"


PRIVATE_KEY=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[1] | .private'`
PRIVATE_KEY_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[1] | .filename'`
sleep 2
echo "PRIVATE_KEY..? $PRIVATE_KEY"
echo "PRIVATE_KEY_NAME..? $PRIVATE_KEY_NAME"
sleep 2
CONFIG=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[2] | .adminconfig'`
CONFIG_NAME=`curl http://$CENTERURL/getAgent/getAdminKey | jq -r '.[2] | .filename'`
 

echo "PUBLIC_KEY..? $PUBLIC_KEY"
echo "PUBLIC_KEY_NAME..? $PUBLIC_KEY_NAME"


## download files
wget http://$CENTERURL$PUBLIC_KEY -O $PUBLIC_KEY_NAME -P $PWD
wget http://$CENTERURL$PRIVATE_KEY -O $PRIVATE_KEY_NAME -P $PWD
wget http://$CENTERURL$CONFIG -O $CONFIG_NAME -P $PWD


## hamonize_admin_user_key 등록
# sudo hamonize-cli authkeys import hamonize-key/private /etc/hamonize/$PUBLIC_KEY_NAME
# sudo hamonize-cli authkeys import hamonize-key/private /etc/hamonize/$PRIVATE_KEY_NAME

# sudo hamonize-cli authkeys setaccessgroup hamonize-key/public $USER
# sudo hamonize-cli authkeys setaccessgroup hamonize-key/private $USER
