: ${SHOW_SETTINGS:=false}

# This is used to prefix resource names such as containers, networks etc...
# If this is not set, the current folder name is used by default.
: ${COMPOSE_PROJECT_NAME:="raw"}

: ${DOCKER_REGISTRY:="artifactory.raw-labs.com/compose"}
: ${RAW_STORAGE_SERVER_BASE_PATH:="/var/tmp/rawcache"}
: ${JAVA_OPTS:=""}

# even though this option is given to the RAW Executor, the path should be relative to the host
# because it will be used to launch the container with the driver using the Docker daemon that runs
# on the host.
: ${EXECUTOR_JAVA_OPTS:="
    -Draw.executor.spark.docker-driver.volumes.0=$(pwd)/conf/raw-driver/logback.xml:/opt/docker/conf/logback.xml:ro
    -Draw.executor.spark.docker-driver.volumes.1=raw_cache:${RAW_STORAGE_SERVER_BASE_PATH}
    -Draw.executor.spark.docker-driver.volumes.2=$(pwd)/conf/raw-driver/core-site.xml:/opt/docker/conf/core-site.xml
    -Draw.executor.spark.docker-driver.image-name=${DOCKER_REGISTRY}/raw-driver-docker-compose
"}

: ${CREDS_JAVA_OPTS:=""}
: ${STORAGE_JAVA_OPTS:=""}
: ${FRONTEND_JAVA_OPTS:=""}

: ${RAW_VERSION:=""}
: ${PUBLIC_ADDRESS:="localhost"}
