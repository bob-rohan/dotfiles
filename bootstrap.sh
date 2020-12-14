#!/usr/bin/env bash

__script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TODO bugfix, existing crontab contents not preserved
echo "installing crontab ${__script_dir}/.crontab"
crontab -l 2>/dev/null; cat ${__script_dir}/.crontab | crontab -

FILENAMES=( .functions .aliases .zshrc )
for FILENAME in "${FILENAMES[@]}"; do
  echo "installing ${__script_dir}/$FILENAME"
  ln -sf ${__script_dir}/$FILENAME ~/$FILENAME
done
