#!/bin/bash
set -x

echo "Adding schedule to CRONTAB."

if [[ -v $SCHEDULE ]]; then
  echo "$SCHEDULE /bin/bash /run.sh" > /etc/crontab
else
  echo "0 4 * * * /bin/bash /run.sh" > /etc/crontab
fi

crontab /etc/crontab
crond -f
