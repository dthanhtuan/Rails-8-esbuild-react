#!/bin/bash

DEV_FILE=.docker/local/Dockerfile
STG_FARGATE_FILE=.docker/fargate/stg/Dockerfile
PRD_FARGATE_FILE=.docker/fargate/prd/Dockerfile

if [ "$1" = "local" ]; then
  ln -f -s ${DEV_FILE} Dockerfile
elif [ "$1" = "stg-fargate" ]; then
  ln -f -s ${STG_FARGATE_FILE} Dockerfile
elif [ "$1" = "prd-fargate" ]; then
  ln -f -s ${PRD_FARGATE_FILE} Dockerfile
else
  echo 'Pass the environment name, "local", "[stg|prd]-fargate"'
  echo '[Usage] ./switch-dockerfile.sh [local|stg-fargate|prd-fargate'
fi
