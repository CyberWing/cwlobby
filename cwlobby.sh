#!/bin/bash

login(){
	read -p "Username: " loginusername
	read -p "Password: " loginpasswd

	userlist=( `cat userdb.db | cut -d':' -f1` )
	passwordlist=( `cat userdb.db | cut -d':' -f2` )
	authcount=0

	until [ $authcount -ge `expr 2 \* ${#userlist[@]}` ]; do
	for x in $userlist; do
		if [ "$x" = $loginusername ]
		then
			for y in $passwordlist; do
				if [ $y = $loginpasswd ]
				then
					echo "Welcome "$(cat userdb.db | grep $loginusername | cut -d':' -f4)
					authcount=`expr 3 \* ${#userlist[@]}`
				else
					echo -n "."
					authcount=`expr $authcount \+ 1`
				fi
			done
		else
			echo -n "."
			authcount=`expr $authcount \+ 1`
		fi
	done
	done

	if [ $authcount -le `expr 2 \* ${#userlist[@]}` ]; then
		echo "[ Invalid Credentials ]"
		exit
	fi
}


login
echo "Other Codes HERE! To be continued"
