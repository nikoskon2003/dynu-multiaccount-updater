#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

input="${SCRIPTPATH}/dynu-updater.list"

if [ ! -f $input ]
then
   echo $'#Example update list file\n#First user' >> $input
   echo $'username=user\npassword=5F4DCC3B5AA765D61D8327DEB882CF99' >> $input
   echo $'hostname=example.com\nhostname=otherdomain.com\nlocation=MyLocation' >> $input
   echo $'\n#Second user' >> $input
   echo $'username=testuser\npassword=098F6BCD4621D373CADE4E832627B4F6' >> $input
   echo $'hostname=somedomain.com\nlocation=Home\nlocation=Office' >> $input
   echo "Please configure $input file!"
   exit
fi

username=""
password=""

while IFS= read -r line
do

   arg="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

   if [[ $arg == "" ]]
   then
       continue
   fi

   if [[ ${arg:0:1} == "#" ]]
   then
       continue
   fi

   if [[ $arg != *"="* ]]
   then
      echo "$(date) | Error: Wrong format - $arg"
      continue
   fi

   name="${arg%=*}"
   val="${arg#*=}"

   if [[ $name == "username" ]]
   then
      username="$val"
      continue
   elif [[ $name == "password" ]]
   then
      password="$val"
      continue
   elif [[ $name == "hostname" ]]
   then
      RESULT="`wget -qO- "https://api.dynu.com/nic/update?username=${username}&hostname=${val}&myip=10.0.0.0&myipv6=no&password=${password}"`"
      echo "$(date) | $val : $RESULT"
   elif [[ $name == "location" ]]
   then
      RESULT="`wget -qO- "https://api.dynu.com/nic/update?username=${username}&location=${val}&myip=10.0.0.0&myipv6=no&password=${password}"`"
      echo "$(date) | $val : $RESULT"
   else
      echo "$(date) | Error: Unknown variable $name"
   fi

done < "$input"
