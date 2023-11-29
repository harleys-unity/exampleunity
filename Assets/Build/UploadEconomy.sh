#!/bin/bash

environment="${1:?Missing Deploy Environment}"
environmentUuid="${2:?Missing Deploy Environment Uuid}"

echo "Uuid: $environmentUuid"

RawEconomy=$(curl -H "Content-Type: application/json" \
  -H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
  --request GET \
  https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources/)

# Got response per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2581
echo "Raw Economy: $RawEconomy"

parsedEconomy=$(jq ".results[].id" <<< "$RawEconomy")

for singleItem in $parsedEconomy; do
	#Remove quotes
	singleItem=$(echo "$singleItem" | sed -e 's/^"//' -e 's/"$//')

	# Got here per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2582
	# ..and returned:
	# 
	# 	curl: (3) URL using bad/illegal format or missing URL
	#
	url="https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources/${singleItem}"
    echo "Deleting item '$singleItem' via $url"
	curl -H "Content-Type: application/json" \
		-H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
		--request DELETE \
		"${url}"
done

find ./Assets/Data/Economy -type f -name "*.json" -print0 | while read -d $'\0' file
do
	# Gets here per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2586
	echo "Reading $file"
	value=`cat $file`

	# Gets here per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2587
	echo "Value: $value"
	currencyId=$(jq ".id" <<< "$value")
	url="https://services.api.unity.com/economy/v2/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/environments/${environmentUuid}/configs/draft/resources"
	echo "URL: $url"

	# Got here per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2600	
	# ..and returned:
	#
	#	[error] {"type":"problems/data/conflict","title":"Conflict error","status":409,"detail":"Item Already Exists","instance":null,"code":10101,"data":{"attempted":{"name":"Coin","id":"TESTCURRENCY","type":"CURRENCY","customData":null,"created":{"date":"2023-11-27T18:33:02Z"},"modified":{"date":"2023-11-27T18:33:02Z"},"initial":10,"max":1000},"existing":{"name":"Coin","id":"TESTCURRENCY","type":"CURRENCY","customData":null,"created":{"date":"2023-11-27T18:17:50Z"},"modified":{"date":"2023-11-27T18:17:50Z"},"initial":10,"max":1000}}}
	#
	curl -H "Content-Type: application/json" \
		-H "Authorization: Basic NjE0NWIwMWMtZTEwOC00ZDRjLTgyNDEtZmNkNmM5MGU1ZDUxOnhZZmt0NGU3ZldwMzJPTk1qWnl3R3Y2ajJuZmZFZE03"  \
		--request POST \
		-d "$value" \
		"${url}"
done


