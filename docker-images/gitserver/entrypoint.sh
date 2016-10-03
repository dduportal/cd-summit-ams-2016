#!/bin/sh

set -e
set -u
set -x

# Rendering conf template
mkdir -p /data/gogs/conf
sed "s#TOKEN_EXTERNAL_URL#${EXTERNAL_URL}#g" /app/app.ini.tpl | \
  sed "s#TOKEN_EXTERNAL_DOMAIN#${EXTERNAL_DOMAIN}#g" | \
  tee /data/gogs/conf/app.ini

# Launching Gogs
sh -c docker/start.sh /bin/s6-svscan /app/gogs/docker/s6/ 2>&1 >/var/log/gogs &

# Configuring Gogs
if [ ! -f /data/.setupdone ]; then
  sh -c /app/setup-gogs.sh
else
  # Wait for gogs startup
  sleep 2
fi

# Listening to log file
tail -f /var/log/gogs
