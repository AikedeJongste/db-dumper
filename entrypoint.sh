#!/bin/bash
set -x

echo "Adding schedule to CRONTAB."

if [[ -v $SCHEDULE ]]; then
  echo "0 4 * * * /run.sh > /dev/stdout 2>&1" > /etc/crontab
else
  echo "$SCHEDULE /run.sh > /dev/stdout 2>&1" > /etc/crontab
fi

crontab /etc/crontab
crond -f -d 8
