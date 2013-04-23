#!/bin/bash

useradd -d "/var/www/${1}" -m -s "/bin/false" -U $1

if [[ $? -eq 0 ]]; then
  chmod u-w "/var/www/${1}"
  chmod g-w "/var/www/${1}"
  exit 0
fi

exit 1
