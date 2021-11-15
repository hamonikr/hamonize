#!/bin/bash  
echo "add ldap backup data" 
echo "$(pwd)" 
echo "...." 

chmod +x /tmp/gs_backup.ldif
chmod +x /tmp/start-ldap.sh

sleep 10

ldapadd -x -D "cn=admin,dc=hamonize,dc=com" -w admin -H ldap://localhost -f /tmp/gs_backup.ldif
