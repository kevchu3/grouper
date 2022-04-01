#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "You must enter exactly 1 argument: the env var name"
  exit 1
fi

. /etc/bashrc
. ~/.bashrc

printenv $1