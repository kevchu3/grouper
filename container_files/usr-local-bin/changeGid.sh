#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "grouperContainer; ERROR: (changeGid.sh) This script must be run as root" 
   exit 1
fi
if [ "$#" -ne 2 ]; then
  echo "grouperContainer; ERROR: (changeGid.sh) You must enter exactly 2 command line arguments: groupname, and gid to change to"
  exit 1
fi
groupname=$1
newGid=$2
getentOutput="$(getent group "$groupname")"
oldGid="$( echo "$getentOutput" |cut -d\: -f3 )"
groupmod -g "$newGid" "$groupname"
echo "grouperContainer; INFO: (changeGid.sh) groupmod -g \"$newGid\" \"$groupname\" , result: $?"
find / -xdev -group "$oldGid" -exec chgrp -h "$groupname" {} \;
echo "grouperContainer; INFO: (changeGid.sh) find / -xdev -group \"$oldGid\" -exec chgrp -h \"$groupname\" {} \; , result: $?"
