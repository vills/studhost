#!/bin/bash

# PARAMS:
#   1 - Username
#   2 - Site domain
#   3 - Type to create
#   4 - Path

# EXIT CODES:
#   0 - All done
#   1 - Some errors

CREATE="/var/www/${1}/${2}/${4}"

if [[ "${3}" = "dir" ]]; then
  su -c "mkdir -p ${CREATE}" $1
else
  su -c "touch ${CREATE}" $1
fi

if [[ $? -lt 1 ]]; then
  exit 0
fi

exit 1
