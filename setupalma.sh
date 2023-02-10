#!/bin/bash
# Basic initialisation install script for AlmaLinux
clear
echo "*** Run This script with Sudo privileges***"
echo
pwd=$(pwd)
basefolder=$(echo $pwd | cut -d '/' -f 3)
baserc=/home/$basefolder/.bashrc
echo
read -t 3 -p  "* Disabling Selinux"  
sudo sed -i '22s/enforcing/disabled/' /etc/selinux/config 2>/dev/null
echo
echo
read -t 3 -p "* Adding aliases to bashrc" 
echo
cat $baserc | egrep "alias ll='ls -l'" || echo "alias ll='ls -l'" >> $baserc
cat $baserc | egrep "alias la='ls -la'" || echo "alias la='ls -la'" >> $baserc
cat $baserc | egrep "alias l='ls'" || echo "alias l='ls'" >> $baserc
cat $baserc | egrep "alias ipa='ip a'" || echo "alias ipa='ip a'" >> $baserc

echo

read -t 3 -p "* Creating scripts folder with PATH variable"
echo
test -d /home/$basefolder/scripts || mkdir /home/$basefolder/scripts 2>/dev/null
cat /home/$basefolder/.bashrc | egrep "export PATH=$PATH:/home/$basefolder/scripts" || echo "export PATH=$PATH:/home/$basefolder/scripts" >> /home/$basefolder/.bashrc 2>/dev/null
source /home/$basefolder/.bashrc
echo
echo
read -t 3 -p "* Updating system and installing packages" 
echo
dnf update -y && 
dnf install epel-release -y &&
dnf install terminator -y &&
dnf install nmap -y && 
dnf install ansible -y &&
dnf install vim -y &&
dnf install ipcalc -y &&
dnf install knock -y

clear
# Changing hostname
hostname=$(cat /etc/hostname)
echo "* Machine hostname is $hostname"
echo "Do you want to change it? [y/n]"
echo
read yesorno

if [ $yesorno = y ];then
        echo "What is the new system hostname ?"
        read hostname
        echo $hostname > /etc/hostname
elif [ $yesorno = n ]; then
echo 
fi
clear
# List all interfaces
interfaces=$(ip a | egrep ^[1-99] | cut -d ":" -f 2)
#ip a | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"   regex ipv4

echo "Interfaces"
echo $interfaces\n
echo
echo "Do you want to configure any interfaces? [y/n]"
read yesorno

if [ $yesorno = y ];then
	clear
        echo "Which interface you want to configure?"
	echo $interfaces
        read confinterface
	echo
	clear
        echo "* Configuring $confinterface"
	echo
	#Creating ifcfg-interface
	touch /etc/sysconfig/network-scripts/ifcfg-$confinterface
	echo "Static or dhcp [s/d]"
	read sord
		if [ $sord = d ];then
			clear
			read -t 3 -p "* Configuring $confinterface as a dhcp client"
			echo BOOTPROTO=dhcp > /etc/sysconfig/network-scripts/ifcfg-$confinterface
			systemctl restart NetworkManager 2>/dev/null
			echo
			read -t 3 -p "* Restarting Network services"
			echo
		elif [ $sord = s ];then
			echo "* Ip address"
			read IPADDR
			echo
			echo "* Subnetmask"
			read NETMASK
			echo
			echo "* Mask Prefix (number only)"
			read PREFIX
			echo
			echo "* Default gateway"
			read GATEWAY
			echo
			echo "* First dns server"
			read DNS1
			echo
			echo "* Second dns server"
			read DNS2
			clear
			read -t 3 -p "* Adding ifcfg config file > /etc/sysconfig/network-scripts/ifcfg-$confinterface"
			echo -e "BOOTPROTO=static\nIPADDR=$IPADDR\nNETMASK=$NETMASK\nPREFIX=$PREFIX\nGATEWAY=$GATEWAY\nDNS1=$DNS1\nDNS2=$DNS2" > /etc/sysconfig/network-scripts/ifcfg-$confinterface
			clear 
			cat /etc/sysconfig/network-scripts/ifcfg-$confinterface
			echo
			echo
			systemctl restart NetworkManager 2>/dev/null
			read -t 3 -p "* Restarting Network services"
			echo



		fi
elif [ $yesorno = n ]; then
echo ""
fi
source $baserc



