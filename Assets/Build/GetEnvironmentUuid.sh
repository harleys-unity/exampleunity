#!/bin/bash

ugs status
ugsEnvs=$(ugs env list)

#echo "UGS Envs $ugsEnvs"

if [[ $ugsEnvs =~ (staging\": \")([^\\S\r\n\"]*) ]]; then
  echo "${BASH_REMATCH[2]}"
fi

