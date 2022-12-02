#!/usr/bin/env bash

FILE=./containers/.env

if [[ -f "$FILE" ]]; then
  echo "Using $FILE to set environment variables..."
  
  # Export env vars using allexport option
  set -o allexport
  source "$FILE"
  set +o allexport

  echo "Done."
fi
