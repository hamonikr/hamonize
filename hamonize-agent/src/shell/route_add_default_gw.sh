#!/usr/bin/env bash

sudo ip route add default via $(route -n |grep ^0.0.0.0.*UG|grep -v tun0|awk -F' ' '{print $2}'|head -1)

