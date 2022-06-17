#!/bin/bash



export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

chmod +x ../2_5.sh
clear 
while true  
do  
  echo 'Checking for size of log file...'
  ../2_5.sh 
  sleep 10
done