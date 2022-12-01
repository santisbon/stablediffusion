#!/usr/bin/env bash

FILE=~/.env

if [[ -f "$FILE" ]]; then
  echo "Setting env variables from $FILE"
  
  # Export env vars using allexport option
  set -o allexport
  source "$FILE"
  set +o allexport
fi
