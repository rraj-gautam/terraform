#!/bin/bash

set -eu

MAIN_FILE="/clamav/store/main.cvd"
addgroup -S clam
adduser -S -G clam -s /bin/bash clam
chown clam.clam /etc/clamav -R
chown clam.clam /var/clamav -R

if [ ! -f ${MAIN_FILE} ]; then
    echo "[bootstrap] Initial clam DB download."
   /usr/bin/freshclam
fi

echo "[bootstrap] Schedule freshclam DB updater."
/usr/bin/freshclam -d -c 6

echo "[bootstrap] Run clamav daemon"
exec su - clam -c /usr/sbin/clamd
