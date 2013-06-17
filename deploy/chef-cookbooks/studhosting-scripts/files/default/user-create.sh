#!/bin/bash

# PARAMS
#   1 - Username
#   2 - Password

useradd -d "/var/www/${1}" -m -s "/bin/sh" -U $1
echo -e "${2}\n${2}\n" | passwd $1

if [[ $? -eq 0 ]]; then
  chmod u-w "/var/www/${1}"
  chmod g-w "/var/www/${1}"
  exit 0
fi

exit 1
