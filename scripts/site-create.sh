#!/bin/bash

USERDIR="/var/www/${1}"

id "${1}" > /dev/null
if [[ $? -gt 0 ]]; then
  exit 2
fi

if [[ -d "$USERDIR" ]]; then
  mkdir -p "${USERDIR}/${2}"
  mkdir -p "${USERDIR}/logs"
  mkdir -p "${USERDIR}/tmp"
  chown www-data:www-data "${USERDIR}/logs"
  chown www-data:www-data "${USERDIR}/tmp"
  chown $1:$1 "${USERDIR}/${2}"

  if [ ! -d "${USERDIR}/${2}" ] && [ ! -d "${USERDIR}/logs" ]; then
    exit 3
  fi

  USERDB="${1}_${2}"
  `mysql -e "create database ${USERDB}";`
  if [[ $? -gt 0 ]]; then
    rm -rf "${USERDIR}/${2}"
    exit 4
  fi

  `mysql -e "grant all privileges on *.* to ${USERDB}@localhost identified by '${3}';"`
  if [[ $? -gt 0 ]]; then
    rm -rf "${USERDIR}/${2}"
    exit 4
  fi

  exit 0
fi

exit 1