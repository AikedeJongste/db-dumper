#!/bin/bash

if [ -z ${MONITORURL+x}  ]; then
  echo "Please configure monitor URL."
else
  echo "Sending start signal to monitoring."
  curl -s $MONITORURL?state=run
fi

# Turn on debugging output
set -x

# Function to execute at the end
cleanup() {
  echo "COMPLETE!"
}

# Register cleanup function to be called on script exit
trap cleanup EXIT

# Destination path
if [ -z ${DESTINATION+x}  ]; then
  echo "Setting DESTINATION to /mnt/target."
  DESTINATION="/mnt/target"
else
  echo "Setting DESTINATION to $DESTINATION ."
  DESTINATION="$DESTINATION"
fi

echo "Current storage usage:"
du -hs $DESTINATION

echo "Current PG_DUMP version:"
/usr/bin/pg_dump --version

DATE=`date +%d`
echo "Target date is: $DATE"
echo "Target host is: $PGHOST"
echo "Target user is: $PGUSER"
echo "Target pass is: $PGPASSWORD"
echo "Target list is: $PGLIST"


if [ -z ${PGLIST+x}  ]; then
  LIST=$(psql -l | grep UTF8 | awk '{ print $1}' | grep -vE '^-|^List|^Name|postgres|azure_sys|azure_maintenance|_dodb|template[0|1]')
else
  LIST=$PGLIST
fi

for d in $LIST
do
  pg_dump -Z1 -Fc $d -f $DESTINATION/daily.$DATE.$d.dump || exit 1
  #pg_dump --format=custom --no-privileges --disable-triggers -Fp | pigz > data.pigz
done


# Notify monitor of completion
if [ -z ${MONITORURL+x}  ]; then
  echo "Please configure monitor URL."
else
  echo "Sending start signal to monitoring."
  curl -s "$MONITORURL?state=complete&msg=Success!"
fi


