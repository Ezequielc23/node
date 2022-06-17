#!/bin/bash


export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

#export size=`du -h node.log`

export size=`du node.log`
echo $size | cat > size.txt 
export size=`cut -c 1,2,3,4,5,6,7 size.txt` 

if [[ $size -gt 1804216 ]]
then
	echo 'log file is big enough to extract telemetry data'
	../goal node stop
	grep -i 'address' ./node.log >> telemetry.txt
	cp ../telemetry.txt $HOME/Desktop/telemetry.txt
else
	echo 
	echo '***Log file is not big enough***'
	echo the size is $size
fi