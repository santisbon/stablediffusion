#!/usr/bin/env bash

#####################################################
# Example ~/.env file
#####################################################
# HUGGINGFACE_TOKEN=xxxxxxxxx
# ARCH=amd64
# PLATFORM=linux/amd64
# STABLEDIFFUSION_TAG=stablediffusion-amd64
# STABLEDIFFUSION_CONDA_ENV_FILE=environment.yaml
# STABLEDIFFUSION_GIT=Stability-AI/stablediffusion
# STABLEDIFFUSION_BRANCH=main
#####################################################

FILE=~/.env

if [[ -f "$FILE" ]]; then
  echo "Setting env variables from $FILE"
  
  # Export env vars using allexport option
  set -o allexport
  source "$FILE"
  set +o allexport
fi
