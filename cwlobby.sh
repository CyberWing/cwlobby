#!/bin/bash

lobby(){
	echo "Welcome"
	echo "1. Register"
	echo "2. Login"
	while read -p "Choose: " lobbychoice
	do
	case $lobbychoice in
		1) register
			;;
		2) login
			;;
		*) echo "Bad Input"
	esac
	done
}

register(){
	read -p "What will be your username: " regusername
	read -p "What will be your password: " regpasswd
	read -p "What will be your email: " regemail
	read -p "What is your real name: " regrealname

	echo $regusername":"$regpasswd":"$regemail":"$regrealname >> userdb.db
}

login(){
	read -p "Username: " loginusername
	read -p "Password: " loginpasswd

	for x in `cat userdb.db | cut -d':' -f1`
	do
		if [ "$x" = $loginusername ]
		then
			for y in `cat userdb.db | cut -d':' -f2`
			do
				if [ $y = $loginpasswd ]
				then
					echo "Welcome "$(cat userdb.db | grep $loginusername | cut -d':' -f4)
					break
				fi
			done
		fi
	done
}
lobby
