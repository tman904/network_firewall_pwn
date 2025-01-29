#!/bin/sh

#date 1/28/2025 @12:31 hours
#Author Tyler K Monroe aka tman904
#Purpose detect if pwn.sh has been installed on a network firewalls file system.

detect=`cat /root/.bashrc |grep -m 1 install`

if [ "$detect" = "install()" ]; then

	echo "system has been compromised please remove /root/.bashrc and restart\n"

else
	echo "system hasn't been compromised .bashrc not found or has normal contents\n"

fi
