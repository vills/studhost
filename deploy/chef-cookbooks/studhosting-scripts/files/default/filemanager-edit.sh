#!/bin/bash

# PARAMS:
#   1 - Username
#   2 - Site domain
#   3 - Temporary filename
#   4 - Path

# EXIT CODES:
#   0 - All done
#   1 - Some errors

EDIT="/var/www/${1}/${2}/${4}"

su -c "cat /tmp/${3} > ${EDIT}" $1

if [[ $? -lt 1 ]]; then
  exit 0
fi

exit 1
