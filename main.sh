#!/bin/bash


waitt(){
#Wait for user to press enter to continue
tput cup 15 35; read -n1 -r -p "Press [Enter] to continue" key
trap " " 2 3 4
until [[ "$key" = "" ]]
do
echo
tput cup 15 35; read -n1 -r -p "Press [Enter] to continue" key;echo
if [[ "$key" = "" ]]; then
clear
tput cup 8 35;echo "Let's Go!"; tput cup 9 40; sleep 1
else
    # Anything else pressed, do whatever else.
echo
tput cup 14 35;tput setaf 011; echo "Invalid Key Press!"
tput setaf 111;
fi
done
trap 2 3 4

}
splash(){ #Function 2: Displays Splash Screen
suline=`tput smul`
ruline=`tput rmul`

tput clear
echo $suline;tput cup 2 35; echo "WELCOME TO NODE MANAGER!"; echo $ruline
echo
echo
echo

waitt
}
terminate(){

clear
export ALGORAND_DATA=$HOME/node/data
cd ~/node
./goal node status
wait 1
clear
tput cup 4 35; echo "No Nodes Started..."

clear
exit 0
}

start_node(){
export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

#echo '{"Enable":true,"SendToLog":true,"URI":"https://myes.es.us-central1.gcp.cloud.es.io","Name":"MyNode","GUID":"494e8ac3-b17a-4ffb-8edc-445b2a3c5c79","FilePath":"$ALGORAND_DATA/tel.log","UserName":"elastic","Password":"2RlaJjnlERbDBgmeH3wDOpWP","MinLogLevel":3,"ReportHistoryLevel":3}' > ./logging.config
echo '{"Enable":true,"SendToLog":false,"URI":"","Name":"$NodeName","GUID":"$GUID","FilePath":"","UserName":"","Password":"","MinLogLevel":3,"ReportHistoryLevel":3}' > ./logging.config
echo 'Starting node...'

export ALGORAND_DATA=$HOME/node/data
cd ~/node


./goal node stop
./algod 
./goal node status


echo 'Node running...'

}

get_data(){
export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

#export size=`du -h node.log`

export size=`du node.log`
echo $size | cat > size.txt 
export size=`cut -c 1,2,3,4,5 size.txt` 

if [[ $size -gt 10216 ]]
then
	echo 'log file is big enough to extract telemetry data'
	../goal node stop
	cp ./node.log ./node.txt
	grep -i 'address' ./node.log >> telemetry.txt
	cp ../telemetry.txt $HOME/Desktop/telemetry.txt
	exit
else
	echo 
	echo '***Log file is not big enough***'
	echo the size is $size
fi
}

check_size(){
export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

chmod +x ../2_5.sh
clear 
while true  
do  
  echo 'Checking for size of log file...'
  get_data
  sleep 5
done

}
status(){
export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

echo 'Getting status...'
cd ..
./goal node status
waitt
menu

}

telemetry_info(){
export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

echo 'Getting telemetry config...'
cd ..
echo
echo
./diagcfg telemetry
waitt
menu

}


setup_node(){

cd $HOME
export ALGORAND_DATA=$HOME/node/data
rm -r .algorand
rm -r node
curl https://raw.githubusercontent.com/danmurphy1217/algorand-quickstart/master/quick-algo -O
mv quick-algo quick-algo.sh
chmod +x quick-algo.sh
sh ./quick-algo.sh
#cp $HOME/Desktop/algo_scripts .
cd node
cp -R $HOME/Desktop/algo_scripts/* .
cd $ALGORAND_DATA/..
echo `./diagcfg telemetry enable` > GUID.txt
export GUID=`cut -c 44- GUID.txt`
export NodeName='myNode'
./diagcfg telemetry name -n $NodeName
rm ../quick-algo.sh
wait 20
menu
}
menu(){
clear; tput cup 1 35; echo "Main Menu"
tput cup 3 35; echo "Select an option: "

tput cup 6 35; echo "0: Setup node"
tput cup 7 35; echo "1: Start & Configure Node"
tput cup 8 35; echo "2: Stop Node & Create telemetryfile"
tput cup 9 35; echo "3: Check Log File size (node.log)"
tput cup 10 35; echo "4: Get Status of Node"
tput cup 11 35; echo "5: Get Telemetry info"
tput cup 12 35; echo "6: Exit"


tput cup 12 42; read input;

case $input in
0) tput cup 14 35; setup_node  ;;
1) tput cup 14 35; start_node ;;
2) tput cup 14 35; get_data;;
3) tput cup 14 35; check_size ;;
4) tput cup 14 35; status ;;
5) tput cup 14 35; telemetry_info;;
6) tput cup 14 35; terminate ;;
*) tput cup 14 35; echo "Invalid Selection!" ;;
esac
sleep .5

}

clear
splash
sleep .5
clear
menu
