#!/bin/bash

npm install --silent -g ugs

if [[ -z "${TARGET_ENVIRONMENT}" ]]; then
  env="build_automation"
else
  env="${TARGET_ENVIRONMENT}"
fi

environmentUuid=$(./Assets/Build/GetEnvironmentUuid.sh $env)

chmod -R a+x ./Assets/Build

echo "Updating $env : $environmentUuid"

./Assets/Build/UploadEconomy.sh $env $environmentUuid
./Assets/Build/UploadCloudCode.sh $env
./Assets/Build/UploadRemoteConfig.sh $env $environmentUuid
