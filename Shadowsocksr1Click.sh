#!/bin/bash
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
install_ssr(){
	clear
	stty erase '^H' && read -p " host:" ssrserver
	stty erase '^H' && read -p " db:" ssrdb
	stty erase '^H' && read -p " user:" ssruser
	stty erase '^H' && read -p " password:" ssrpd
	stty erase '^H' && read -p " node_id:" ssrid
	[[ -z ${ssrid} ]] && ssrid=0
	stty erase '^H' && read -p " transfer_mul:" ssrmul
	[[ -z ${ssrmul} ]] && ssrmul=1
	stty erase '^H' && read -p " speed_limit:" ssrspeed
	[[ -z ${ssrspeed} ]] && ssrspeed=0
	clear
  	git clone -b akkariiin/dev https://github.com/ggcs/shadowsocksr.git && cd shadowsocksr && chmod +x setup_cymysql.sh && chmod +x ./initcfg.sh && ./setup_cymysql.sh && ./initcfg.sh
	rm -rf Shadowsocksr1Click.sh
	echo 'ssr安装完成'
	
	sed -i -e "s/ssrserver/$ssrserver/g" usermysql.json
	sed -i -e "s/ssrdb/$ssrdb/g" usermysql.json
	sed -i -e "s/ssruser/$ssruser/g" usermysql.json
	sed -i -e "s/ssrpd/$ssrpd/g" usermysql.json
	sed -i -e "s/ssrid/$ssrid/g" usermysql.json
	sed -i -e "s/ssrmul/$ssrmul/g" usermysql.json
	sed -i -e "s/ssrspeed/$ssrspeed/g" user-config.json
	echo 'ssr配置完成'
	
	chmod +x run.sh && ./run.sh
	echo 'ssr已开始运行'
	
	read -e -p "是否添加守护？[Y/n]" ssr_Daemon
	if [[ ${ssr_Daemon} != [Nn] ]];then
		chmod +x Daemon.sh
		if [ ! -d "//var/spool/cron/crontabs/" ];then
			echo "*/1 * * * * /root/shadowsocksr/Daemon.sh" >> /var/spool/cron/root
		else
			echo "*/1 * * * * /root/shadowsocksr/Daemon.sh" >> /var/spool/cron/crontabs/root
		fi
		echo 'ssr已被守护'
	fi
	
	cd /root/
	rm -rf Shadowsocksr1Click.sh
	echo '执行完毕'
}
apt-get install git
install_ssr
