#!/bin/sh
# expect and send input values to openvpn-install.sh
# get public ip by 'curl ifconfig.me' command
curl -o iptmp.txt ifconfig.me && IP=$(cat iptmp.txt) && rm iptmp.txt

expect <<END
	spawn bash openvpn-install.sh 
	expect "IP address:*"
	send -- "\r"
	expect "Public IP address / hostname:*"
	send -- "$IP\r"
	expect "Protocol*"
        send -- "\r"
	expect "Port:*"
	send -- "\r"
	expect "DNS*"
	send -- "\r"
	expect "Client name:*"
        send -- "\r"
	expect "Press any key to continue...*"
	send -- "\r"
	expect
END
