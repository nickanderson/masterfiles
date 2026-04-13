#!/usr/bin/env bash
set -ex

# find the dir two levels up from here, home of all the repositories
COMPUTED_ROOT="$(readlink -e "$(dirname "$0")/../../")"
# NTECH_ROOT should be the same, but if available use it so user can do their own thing.
NTECH_ROOT=${NTECH_ROOT:-$COMPUTED_ROOT}
CFENGINE_VERSION=${1:-master}

cd "${NTECH_ROOT}/masterfiles"

# cleanup
rm -f update.log bootstrap.log promise.log
image_name=bootstrap-${CFENGINE_VERSION}
if docker ps | grep "$image_name"; then
  docker stop "$image_name"
fi
if docker ps -a | grep "$image_name"; then
  docker ps -a | grep "$image_name" | awk '{print $1}' | xargs docker rm
fi
if docker images | grep "$image_name"; then
  docker rmi "$image_name"
fi

# run the test
docker build -t "$image_name" --build-arg CFENGINE_VERSION="$CFENGINE_VERSION" -f "${NTECH_ROOT}"/masterfiles/ci/bootstrap-policy-run.Dockerfile  "${NTECH_ROOT}"
docker run --workdir /masterfiles --tty "$image_name" sh /masterfiles/ci/bootstrap-policy-run.sh
if grep error *.log; then
  echo "fail"
  exit 1
else
  echo "success"
fi
