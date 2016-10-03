#!/bin/sh
#
# This script will auto-configure a "blank" app stack for the demo

set -e
set -u
set -x


ARTEFACT_SERVER_URL=http://localhost:8081
SHARED_M2_REPOSITORY=/local-m2-cache
ADMIN_USERNAME=admin
ADMIN_PASSWORD=password

sh -c /tmp/run.sh 2>&1 1>/var/log/artifactory-first-start.log &

# Waiting for ARTIFACTORY_SERVER to start
while true; do
  curl --fail -v -X GET "${ARTEFACT_SERVER_URL}/artifactory/webapp" \
  && break ||
    echo "Artifactory Server still not started, waiting 2s before retrying"

  sleep 2
done

echo "== Configuring Artifactory"

curl -u ${ADMIN_USERNAME}:${ADMIN_PASSWORD} \
  -X POST -H "Content-type:application/xml" \
  --data-binary @/app/artifactory.config.xml \
    "${ARTEFACT_SERVER_URL}/artifactory/api/system/configuration"

if [ -d "${SHARED_M2_REPOSITORY}" ]; then
  echo "== Configuring Artifactory"

  curl -u ${ADMIN_USERNAME}:${ADMIN_PASSWORD} \
   -X POST -H "Content-Type: application/json" \
    --data '{"action":"repository","repository":"local-cache","path":"'${SHARED_M2_REPOSITORY}'","excludeMetadata":false,"verbose":true}' \
      "${ARTEFACT_SERVER_URL}/artifactory/ui/artifactimport/repository"

fi

echo "== Configuration done."
exit 0
