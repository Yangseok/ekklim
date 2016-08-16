#!/bin/bash

################### Config ##################
srv_idx=1

PROMPT=1  # 0: Default Parameter   1: Input Parameter

iDIR=("/root/install.log" "/root/anaconda-ks.cfg" "/var/log/installer/syslog")
App="httpd\|samba-common\|mysqld\|mariadb\|bind\|gluster\|vsftpd\|php-common"
rPS="httpd\|smbd\|mysqld\|bind\|gulster\|vsftpd\|tomcat\|snmpd\|rsync\|openfire\|asterisk\|fmscore\|qmail"

L1="====================="
L2="---"

L_Rep=/hometools/report/`date +%Y%m%d_%H%M`
URI=http://192.168.11.111/~test/report/srvreport_insert.php

if [ ! -d  /hometools/report ];then
	echo -e "Error... Make the directory!! /scripts/M_Report"
	exit
fi

if [ "$PROMPT" = "0" ];then
	echo "Input Change_Time (1 to 9)"
	read C_T
	echo "Do you want to Transfer Thins Report (y or n)"
	read TRANSFER
else
	C_T=3
	TRANSFER=n
fi

#############################################

##### 1. Server Information

clear

SRVINFO ()
{
	OS=`find /etc/*-release | xargs cat | grep 'PRETTY_NAME' | awk -F = '{print $2}' | tr -d '"'`
	if [ -z "$OS" ]
	then
		OS=`find /etc/*-release | xargs cat | uniq`
	fi
		KERNEL=`uname -r`

	for no in ${!iDIR[@]}
	do
		if [ -e ${iDIR[$no]} ]
		then
			iDATE=`ls -al --time-style full-iso ${iDIR[$no]} | awk '{print $6}'`
		fi
	done

	UPTIME=`uptime`
	PID1=`ps -p 1 | tail -1 | awk '{print $4}'`
	HV=`lscpu | grep 'Hypervisor' | awk -F : '{print $2}' | tr -d " "`
	if [ -z "$HV" ]
	then
		HV=Hosted
	fi
		TIME=`date`

	echo -e $L1" 1. Server Information"$L1 | tee $L_Rep.txt
	echo -e $L2" 1) OS " | tee -a $L_Rep.txt
	echo -e "$OS\n" | tee -a $L_Rep.txt
	echo -e $L2" 2) Kernel " | tee -a $L_Rep.txt
	echo -e "$KERNEL\n" | tee -a $L_Rep.txt
	echo -e $L2" 3) Install Date " | tee -a $L_Rep.txt
	echo -e "$iDATE\n" | tee -a $L_Rep.txt
	echo -e $L2" 4) Uptime " | tee -a $L_Rep.txt
	echo -e "$UPTIME\n" | tee -a $L_Rep.txt
	echo -e $L2" 5) PID 1 " | tee -a $L_Rep.txt
	echo -e "$PID1\n" | tee -a $L_Rep.txt
	echo -e $L2" 6) Hosted or VM " | tee -a $L_Rep.txt
	echo -e "$HV\n" | tee -a $L_Rep.txt
	echo -e $L2" 7) Server Date " | tee -a $L_Rep.txt
	echo -e "$TIME\n" | tee -a $L_Rep.txt
	echo -e $L1"======================"$L1
}

SRVINFO
sleep $C_T;clear

#### 2. H/W Information

HWINFO ()
{
	CPU=`lscpu | grep 'Model name' | awk -F : '{print $2}' | tr -d "   "`
	if [ -z "$CPU" ]
	then
		CPU=`cat /proc/cpuinfo | grep "model name" | uniq | awk -F : '{print $2}'`
	fi

	MEM=`cat /proc/meminfo | grep 'MemTotal\|MemFree'`
	FREE=`free -h`
	DFH=`df -h`

	echo -e $L1" 2. H/W Information"$L1 | tee -a $L_Rep.txt
	echo -e $L2" 1) CPU " | tee -a $L_Rep.txt
	echo -e "$CPU\n" | tee -a $L_Rep.txt
	echo -e $L2" 2) Memory " | tee -a $L_Rep.txt
	echo -e "$MEM\n" | tee -a $L_Rep.txt
	echo -e $L2" 3) Memory info " | tee -a $L_Rep.txt
	echo -e "$FREE\n" | tee -a $L_Rep.txt
	echo -e $L2" 4) Disk Partion info " | tee -a $L_Rep.txt
	echo -e "$DFH\n" | tee -a $L_Rep.txt
	echo -e $L1"==================="$L1
}

HWINFO
sleep $C_T;clear

#### 3. Network Information

NETINFO ()
{
	IP=`ip a | grep 'inet' | grep brd | awk '{print $2}' | awk -F / '{print $1}'`
	DNS=`cat /etc/resolv.conf | grep nameserver`
	FW=`iptables -L -n | grep 'INPUT\|OUTPUT'`
	TCP=`ss -atn | grep 'LISTEN'`
	SS=`ss -atn | grep 'ESTAB' | wc -l`

	echo -e $L1" 3. Network Information"$L1 | tee -a $L_Rep.txt
	echo -e $L2" 1) IP Address " | tee -a $L_Rep.txt
	echo -e "$IP\n" | tee -a $L_Rep.txt
	echo -e $L2" 2) DNS " | tee -a $L_Rep.txt
	echo -e "$DNS\n" | tee -a $L_Rep.txt
	echo -e $L2" 3) Firewall" | tee -a $L_Rep.txt
	echo -e "$FW\n" | tee -a $L_Rep.txt
	echo -e $L2" 4) TCP Listen " | tee -a $L_Rep.txt
	echo -e "$TCP\n" | tee -a $L_Rep.txt
	echo -e $L2" 5) ESTABLISHED Session " | tee -a $L_Rep.txt
	echo -e "$SS\n" | tee -a $L_Rep.txt
	echo -e $L1"======================="$L1
}

NETINFO
sleep $C_T;clear

#### 4. Application Information

APPINFO ()
{
	RPM=`which rpm`
	RPM=$?
	if [ $RPM != 0 ]
	then
		iAPP=`dpkg -l | grep $App`
	else
		iAPP=`rpm -qa | grep $App`
	fi

	PS=`ps -ef | grep $rPS | awk '{print $1, $8}' | grep -v 'grep' | uniq`
	PSC=`ps -ef | wc -l`
	TopPS=`top b -n1 | head -12 | tail -6`
	VMSTAT=`vmstat`

	echo -e $L1" 4. App and ps Information"$L1 | tee -a $L_Rep.txt
	echo -e $L2" 1) Installed Application " | tee -a $L_Rep.txt
	echo -e "$iAPP\n" | tee -a $L_Rep.txt
	echo -e $L2" 2) Process" | tee -a $L_Rep.txt
	echo -e "$PS\n" | tee -a $L_Rep.txt
	echo -e $L2" 3) No of Process" | tee -a $L_Rep.txt
	echo -e "$PSC\n" | tee -a $L_Rep.txt
	echo -e $L2" 4) Top 5 Process" | tee -a $L_Rep.txt
	echo -e "$TopPS\n" | tee -a $L_Rep.txt
	echo -e $L2" 5) vmstat" | tee -a $L_Rep.txt
	echo -e "$VMSTAT\n" | tee -a $L_Rep.txt
	echo -e $L1"========================"$L1
}

APPINFO
sleep $C_T;clear

#### 5. Etc Information

ETC()
{
	SYSAcc=`cat /etc/passwd | awk -F: '$3 > 500 {print $1}' | wc -l`
	CROND=`crontab -l`

	echo -e $L1" 5. ETC Information"$L1 | tee -a $L_Rep.txt
	echo -e $L2" 1) No of Accounts " | tee -a $L_Rep.txt
	echo -e "$SYSAcc\n" | tee -a $L_Rep.txt
	echo -e $L2" 2) Crontab List" | tee -a $L_Rep.txt
	echo -e "$CROND\n" | tee -a $L_Rep.txt
	echo -e $L1"========================"$L1 | tee -a $L_Rep.txt
}

ETC
sleep $C_T;clear

#### Remote transfer
if [ "$TRANSFER" = "y" ];then
	REPORT=`cat $L_Rep.txt`
	curl -d "srv_idx=$srv_idx&report=$REPORT" $URI
	echo -e "Success Transfer!! " $URI
else
	exit
fi
