#!/bin/sh
set -e

# Find root folder
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
export SCRIPT_DIR
cd "${SCRIPT_DIR}"

# Setup environment
# shellcheck disable=SC1090
. "${SCRIPT_DIR}"/settings.sh

if [ -z "${RAW_VERSION}" ]
then
	echo "Please set RAW_VERSION, exiting..."
	exit 1
fi

if [ "$1" = "up" ]
then
	echo "-- Pulling images"
	docker pull "${DOCKER_REGISTRY}"/raw-driver-docker-compose:"${RAW_VERSION}"
	echo ""
fi
# shellcheck disable=SC2145
echo "-- Executing \"docker-compose -f ${COMPOSE_FILE} $@\""
docker-compose -f "${COMPOSE_FILE}" "$@"
