#!/bin/bash
set -x

echo "Adding schedule to CRONTAB."

if [[ -z $SCHEDULE ]]; then
  echo "Setting default schedule."
  echo "0 4 * * * /run.sh > /dev/stdout 2>&1" > /etc/crontab
else
  echo "Setting custom schedule."
  echo "$SCHEDULE /run.sh > /dev/stdout 2>&1" > /etc/crontab
fi

crontab /etc/crontab
crond -f -d 8
