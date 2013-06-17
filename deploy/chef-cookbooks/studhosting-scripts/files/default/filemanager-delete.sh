#!/bin/bash

# PARAMS:
#   1 - Username
#   2 - Site domain
#   3 - Path

# EXIT CODES:
#   0 - All done
#   1 - Some errors

DEL="/var/www/${1}/${2}/${3}"

su -c "rm -rf ${DEL}" $1

if [[ $? -lt 1 ]]; then
  exit 0
fi

exit 1
