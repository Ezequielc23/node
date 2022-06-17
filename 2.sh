#!/bin/bash


export ALGORAND_DATA=$HOME/node/data
cd ~/node


./goal node stop
./algod 
./goal node status

