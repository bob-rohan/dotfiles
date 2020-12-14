#!/usr/bin/env bash

__script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FILENAMES=( .functions .aliases .zshrc )
for FILENAME in "${FILENAMES[@]}"; do
  echo "installing ${__script_dir}/$FILENAME"
  ln -sf ${__script_dir}/$FILENAME ~/$FILENAME
done
