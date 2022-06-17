#!/bin/bash


export ALGORAND_DATA=$HOME/node/data
cd $ALGORAND_DATA

echo '{"Enable":true,"SendToLog":true,"URI":"https://myes.es.us-central1.gcp.cloud.es.io","Name":"MyNode","GUID":"494e8ac3-b17a-4ffb-8edc-445b2a3c5c79","FilePath":"$ALGORAND_DATA/tel.log","UserName":"elastic","Password":"2RlaJjnlERbDBgmeH3wDOpWP","MinLogLevel":3,"ReportHistoryLevel":3}' > ./logging.config

echo 'Starting node'

chmod +x $HOME/node/2.sh
chmod +x $HOME/node/2_7.sh
chmod +x $HOME/node/3.sh
sh $HOME/node/2.sh

echo 'Node running...'

