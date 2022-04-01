#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "You must enter exactly 1 argument: the file name"
  exit 1
fi

if [ -f "$1" ]; then
  echo "exists"
fi