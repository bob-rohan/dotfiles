#!/bin/bash
#
#
# modified aws-azure-login
#
# TODOs
# - other awsauth stuff, keys and whitelists
# - refactor to awsauth repo
#
# prereqs: azuread key in keychain
# pros and cons discussed here https://www.netmeister.org/blog/keychain-passwords.html
#
# security delete-generic-password -a ${USER} -s azuread
# security add-generic-password -a ${USER} -s azuread -w

export AZURE_DEFAULT_PASSWORD=$(security find-generic-password -a bob.rohan -s azuread -w /Users/${USER}/Library/Keychains/login.keychain-db)

if [ -z $1 ]; then
  /usr/local/bin/aws-azure-login aws-azure-login --no-prompt --all-profiles
else
  AWS_PROFILE=$1
  aws sts get-caller-identity &>/dev/null
  IS_SESSION_VALID=$?

  if [ $IS_SESSION_VALID -ne 0 ]; then
    echo "refreshing $1 creds"
    /usr/local/bin/aws-azure-login aws-azure-login --no-prompt --profile $1
  fi
fi

unset AZURE_DEFAULT_PASSWORD
