: ${SHOW_SETTINGS:=false}

# This is used to prefix resource names such as containers, networks,
# etc... If this is not set, the current folder name is used by default.
: ${COMPOSE_PROJECT_NAME:="raw"}

: ${RAW_LOGS:="/tmp/raw-driver-logs"}
: ${RAW_DATA:="$(pwd)/data"}

: ${RAW_EXECUTOR_PORT:="54321"}
: ${RAW_FRONTEND_PORT:="9000"}

: ${PROXY_HTTP_PORT:="80"}
: ${PROXY_HTTPS_PORT:="443"}
: ${COMPOSE_FILE:="docker-compose.yml"}

: ${RAW_VERSION:=""}
: ${PUBLIC_ADDRESS:="localhost"}

: ${DOCKER_REGISTRY:="artifactory.raw-labs.com/compose"}
: ${JAVA_OPTS:=""}

# Even though this option is given to the RAW Executor, the path should
# be relative to the host because it will be used to launch the container
# with the driver using the Docker daemon that runs on the host.

# Uncomment, or copy this to your local settings to expose the Spark driver.
#: ${SPARK_PORT:="-Draw.executor.spark.docker-driver.ports.0=4040:4040"}
: ${SPARK_PORT:=""}

# Spark is starting the containers for the workers by itself, outside of
# docker-compose, which means we have to prefix ourselves in the same way
# the docker volume names used, for example for the raw cache. The prefix
# to use is `${COMPOSE_PROJECT_NAME}_`.
: ${EXECUTOR_JAVA_OPTS:="
    ${SPARK_PORT}
    -Draw.executor.spark.docker-driver.volumes.0=$(pwd)/conf/raw-driver/logback.xml:/opt/docker/conf/logback.xml:ro
    -Draw.executor.spark.docker-driver.volumes.1=${COMPOSE_PROJECT_NAME}_cache:/var/tmp/rawcache
    -Draw.executor.spark.docker-driver.volumes.2=$(pwd)/conf/raw-driver/core-site.xml:/opt/docker/conf/core-site.xml:ro
    -Draw.executor.spark.docker-driver.volumes.3=${RAW_DATA}:/data:ro
    -Draw.executor.spark.docker-driver.image-name=${DOCKER_REGISTRY}/raw-driver-docker-compose
"}

: ${CREDS_JAVA_OPTS:=""}
: ${STORAGE_JAVA_OPTS:=""}
: ${FRONTEND_JAVA_OPTS:=""}
