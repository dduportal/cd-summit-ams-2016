#!/bin/sh
#
# This script will auto-configure a "blank" app stack for the demo

set -e
set -u
set -x

# Fetching port used by Gogs from its configuration
GITSERVER_PORT=$(grep HTTP_PORT /data/gogs/conf/app.ini | awk '{print $3}')
# We use localhost since we already are inside the gogs container there
GITSERVER_HOST_PORT="localhost:${GITSERVER_PORT}"
GITSERVER_URL="http://${GITSERVER_HOST_PORT}"
GITSERVER_API_URL="${GITSERVER_URL}/api/v1"
# Provides FIRST_USER and FIRST_REPO_NAME as container env vars
REPO_GIT_URL="http://${FIRST_USER}:${FIRST_USER}@${GITSERVER_HOST_PORT}/${FIRST_USER}/${FIRST_REPO_NAME}.git"


# Waiting for Gitserver to start
while true; do
  curl --fail -X GET "${GITSERVER_URL}" \
  && break ||
    echo "Git Server still not started, waiting 2s before retrying"

  sleep 2
done

echo "== Configuring Git Server"

# We create the first user
curl -X POST -s \
  -F "user_name=${FIRST_USER}" \
  -F "email=${FIRST_USER}@localhost.local" \
  -F "password=${FIRST_USER}" \
  -F "retype=${FIRST_USER}" \
  ${GITSERVER_URL}/user/sign_up

# Create initial repository
curl -X POST -s \
  -F "uid=1" \
  -F "name=${FIRST_REPO_NAME}" \
  -u "${FIRST_USER}:${FIRST_USER}" \
  ${GITSERVER_API_URL}/user/repos

# Load SSH keys to avoid password laters
# curl -X POST -s \
#   -F "title=insecure_demo_key" \
#   -F "key=$(cat ${SSH_KEY_PATTERN}.pub)" \
#   -u "${FIRST_USER}:${FIRST_USER}" \
#   ${GITSERVER_API_URL}/admin/users/${FIRST_USER}/keys

# Load our local repository inside the newly created one
rm -rf /tmp/${FIRST_REPO_NAME}/*
git clone --bare ${SOURCE_REPO_TO_MIRROR} "/tmp/${FIRST_REPO_NAME}"
( cd "/tmp/${FIRST_REPO_NAME}" \
    && git push --mirror ${REPO_GIT_URL}
)

touch /data/.setupdone

echo "== Configuration done."
exit 0
