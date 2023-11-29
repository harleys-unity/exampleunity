#!/bin/bash

environment="${1:?Missing Deploy Environment}"
environmentUuid="${2:?Missing Deploy Environment Uuid}"

echo "EnvID: $environmentUuid"

projectId="a375a73a-50d3-4500-87b2-c1bfea97f757"
authkey="NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"

echo "URL https://services.api.unity.com/remote-config/v1/projects/$projectId/environments/$environmentUuid/configs"

configJson=$(curl -X GET \
https://services.api.unity.com/remote-config/v1/projects/$projectId/environments/$environmentUuid/configs \
  -H "Authorization: Basic $authkey")
  
echo "rawJson: $configJson"
  
parsedConfigs=$(jq -c '.configs[0].value[]' <<< "$configJson")
configId=$(jq -cr '.configs[0].id' <<< "$configJson")
echo "ConfigId: $configId"

for singleItem in $parsedConfigs; do
    echo "item: $singleItem"
done


configFileValue=$(jq -c '.' ./Assets/Data/RemoteConfig/RemoteConfig.json)
echo "File: $configFileValue"

updatingJson=$(echo $configFileValue | sed -e "s/ENVID/$environmentUuid/g")
		  
echo $updatingJson	  


if [ -z "$configId" ]; then 
	curl -X POST \
		https://services.api.unity.com/remote-config/v1/projects/$projectId/configs \
		  -H 'Authorization: Basic $authkey' \
		  -H "Content-Type: application/json" \
		  -d $updatingJson
else
	curl -X PUT \
		https://services.api.unity.com/remote-config/v1/projects/$projectId/configs/$configId \
		  -H "Authorization: Basic $authkey" \
		  -H "Content-Type: application/json" \
		  -d $updatingJson
	

fi


