#!/bin/bash

horbar(){
        ccount=0
        until [ $ccount -eq $(tput cols) ]
        do
                echo -n "="
                ccount=`expr $ccount + 1`
        done
        echo 
}

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

ipclasses(){
	echo "IP address classes

   +------------------------------------------------------------------------+
   |     |1^st    |1^st |Network/Host|              |         |Hosts per    |
   |     |Octet   |Octet|ID          |Default Subnet|Number of|Network      |
   |Class|Decimal |High |(N=Network, |Mask          |Networks |(Usable      |
   |     |Range   |Order|H=Host)     |              |         |Addresses)   |
   |     |        |Bits |            |              |         |             |
   |-----+--------+-----+------------+--------------+---------+-------------|
   |A    |1 - 126*|0    |N.H.H.H     |255.0.0.0     |126 (2^7 |16,777,214   |
   |     |        |     |            |              |- 2)     |(2^24 - 2)   |
   |-----+--------+-----+------------+--------------+---------+-------------|
   |     |128 -   |     |            |              |16,382   |65,534 (2^16 |
   |B    |191     |10   |N.N.H.H     |255.255.0.0   |(2^14 -  |- 2)         |
   |     |        |     |            |              |2)       |             |
   |-----+--------+-----+------------+--------------+---------+-------------|
   |     |192 -   |     |            |              |2,097,150|             |
   |C    |223     |110  |N.N.N.H     |255.255.255.0 |(2^21 -  |254 (2^8 - 2)|
   |     |        |     |            |              |2)       |             |
   |-----+--------+-----+---------------------------------------------------|
   |D    |224 -   |1110 |Reserved for Multicasting                          |
   |     |239     |     |                                                   |
   |-----+--------+-----+---------------------------------------------------|
   |E    |240 -   |1111 |Experimental; used for research                    |
   |     |254     |     |                                                   |
   +------------------------------------------------------------------------+

   Note: Class A addresses 127.0.0.0 to 127.255.255.255 cannot be used and is
   reserved for loopback and diagnostic functions.

Private IP Addresses

   +------------------------------------------------------------------------+
   | Class | Private Networks | Subnet Mask | Address Range                 |
   |-------+------------------+-------------+-------------------------------|
   | A     | 10.0.0.0         | 255.0.0.0   | 10.0.0.0 - 10.255.255.255     |
   |-------+------------------+-------------+-------------------------------|
   | B     | 172.16.0.0 -     | 255.240.0.0 | 172.16.0.0 - 172.31.255.255   |
   |       | 172.31.0.0       |             |                               |
   |-------+------------------+-------------+-------------------------------|
   | C     | 192.168.0.0      | 255.255.0.0 | 192.168.0.0 - 192.168.255.255 |
   +------------------------------------------------------------------------+"
}

endecrypt(){
	read -p "1. Encrypt; 2. Decrypt; 3. Digest(MD5): " endecwhich
	if [ $endecwhich -eq 1 ]; then
		read -p "Input: " endecEinput
		echo "Encrypted Text: "$(echo -n "$endecEinput" | openssl enc -base64)
	elif [ $endecwhich -eq 2 ]; then
		read -p "Input: " endecDinput
		echo "Decrypted Text: "$(echo "$endecDinput" | openssl enc -base64 -d)
	elif [ $endecwhich -eq 3 ]; then
		read -p "Input: " endecDgstInput
		echo "Digested Text: " && echo -n "$endecDgstInput" | openssl dgst -md5 | awk '{print $2}'
	else
		echo "Error Input"
	fi
}

menu(){
  echo "Welcome to Cyber Wings Lobby"
  echo "1. IP Classes List"
  echo "2. En/Decrypt"
  echo "99. Exit"
  while true; do
  read -p "Your Choice: " userinput

  case $userinput in
    1) horbar
       ipclasses
       horbar
      ;;
    2) horbar
       endecrypt
       horbar
      ;;
    99)echo  "==================== BYE ===================="
       exit 0
      ;;
    *) echo "invalid input"
  esac
  done
}
login
menu
echo "Other Codes HERE! To be continued"
