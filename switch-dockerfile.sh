#!/bin/bash

DEV_FILE=.docker/local/Dockerfile
PRD_FILE=.docker/prd/Dockerfile

if [ "$1" = "local" ]; then
  ln -f -s ${DEV_FILE} Dockerfile
elif [ "$1" = "prd" ]; then
  ln -f -s ${PRD_FILE} Dockerfile
else
  echo 'Pass the environment name, "local", "[prd]"'
  echo '[Usage] ./switch-dockerfile.sh [local|prd]"'
fi
