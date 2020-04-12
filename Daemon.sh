#!/bin/bash
python_ver=$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+$"|tail -1)
ps -ef | grep "[0-9] ${python_ver} server\\.py m"
if [ $? -ne 0 ]
then
	cd `dirname $0`
	ulimit -n 512000
	ulimit -u 512000
	nohup ${python_ver} server.py m>> /dev/null 2>&1 &
fi
