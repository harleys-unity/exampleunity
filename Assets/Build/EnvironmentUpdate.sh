#!/bin/bash

npm install --silent -g ugs

if [[ -z "${TARGET_ENVIRONMENT}" ]]; then
  env="build_automation"
else
  env="${TARGET_ENVIRONMENT}"
fi

environmentUuid=$(./Assets/Build/GetEnvironmentUuid.sh $env)

chmod -R a+x ./Assets/Build

# Successfully got UUID per logs: https://cloud.unity.com/home/organizations/3574059654190/projects/a375a73a-50d3-4500-87b2-c1bfea97f757/cloud-build/buildtargets/devops-test-build-windows/builds/13/log#L2573
echo "Updating $env : $environmentUuid"


./Assets/Build/UploadEconomy.sh $env $environmentUuid
./Assets/Build/UploadCloudCode.sh $env
./Assets/Build/UploadRemoteConfig.sh $env $environmentUuid
