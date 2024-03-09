#!/bin/bash

echo "Sending start signal to monitoring."
curl -s $MONITOR_URL?state=run

# Turn on debugging output
set -x

# Function to execute at the end
cleanup() {
  echo "COMPLETE!"
}

# Register cleanup function to be called on script exit
trap cleanup EXIT

# Destination path
DESTINATION="/mnt/target"

echo "Current storage usage:"
du -hs $DEST_PATH

echo "Current PG_DUMP version:"
/usr/bin/pg_dump --version

echo "Target host is: $PGHOST"
echo "Target user is: $PGUSER"
echo "Target pass is: $PGPASS"

DATE=`date +%d`
LIST=$(psql -l | grep UTF8 | awk '{ print $1}' | grep -vE '^-|^List|^Name|template[0|1]')

for d in $LIST
do
  pg_dump -Z1 -Fc $d -f $DESTINATION/daily.$DATE.$d.dump || exit 1
  #pg_dump --format=custom --no-privileges --disable-triggers -Fp | pigz > data.pigz
done


# Notify monitor of completion
curl -s "$MONITOR_URL?state=complete&msg=Success!"


