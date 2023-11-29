#!/bin/bash

environment="${1:?Missing Deploy Environment}"
environmentUuid="${2:?Missing Deploy Environment Uuid}"

echo "Uuid: $environmentUuid"

RawEconomy=$(curl -H "Content-Type: application/json" \
  -H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
  --request GET \
https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources/)

echo "Raw Economy: $RawEconomy"

parsedEconomy=$(jq ".results[].id" <<< "$RawEconomy")

for singleItem in $parsedEconomy; do
	#Remove quotes
	singleItem=$(echo "$singleItem" | sed -e 's/^"//' -e 's/"$//')
    echo "Deleting item: $singleItem"
	url="https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources/${singleItem}"
	curl -H "Content-Type: application/json" \
		-H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
		--request DELETE \
		${url}
done

find ./Assets/Data/Economy -type f -name "*.json" -print0 | while read -d $'\0' file
do
	echo "Reading $file"
	value=`cat $file`
	echo "$value"
	currencyId=$(jq ".id" <<< "$value")
	url="https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources"
	
	curl -H "Content-Type: application/json" \
		-H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
		--request POST \
		-d "$value" \
		${url}
done


