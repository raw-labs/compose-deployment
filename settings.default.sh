#!/bin/sh
# shellcheck disable=SC2223
: ${SHOW_SETTINGS:=false}

# This is used to prefix resource names such as containers, networks,
# etc... If this is not set, the current folder name is used by default.
: ${COMPOSE_PROJECT_NAME:="raw"}

: ${RAW_LICENSE:="$(pwd)/conf/raw.license"}
: ${RAW_LOGS:="$(pwd)/logs"}
: ${RAW_CACHE:="$(pwd)/raw-cache"}

# Folder containing local data files.
: ${RAW_DATA_SOURCE:="$(pwd)/data"}
# Where to mount the local data folder within the container.
: ${RAW_DATA_TARGET:="/data"}

: ${RAW_EXECUTOR_PORT:="54321"}
: ${RAW_CREDS_PORT:="54322"}
: ${RAW_STORAGE_PORT:="54323"}
: ${RAW_FRONTEND_PORT:="9000"}
: ${RAW_JUPYTER_PORT:="8888"}

: ${PROXY_HTTP_PORT:="80"}
: ${PROXY_HTTPS_PORT:="443"}
: ${COMPOSE_FILE:="docker-compose.yml"}

: ${PROXY_CERTS_CRT:="$(pwd)/conf/certs/proxy.crt"}
: ${PROXY_CERTS_KEY:="$(pwd)/conf/certs/proxy.key"}
: ${AUTH_CONF:="$(pwd)/conf/auth-none.conf"}

: ${RAW_VERSION:="1.14.35"}
: ${PUBLIC_ADDRESS:="localhost"}

# Heap size of the driver, e.g., -Xmx${RAW_DRIVER_MEM} as an argument to the driver's JVM
: ${RAW_DRIVER_MEM:="8g"}

# Number of cores used by Spark, e.g., -Dspark.master=local[$RAW_DRIVER_CORES] as an argument to the driver's JVM 
: ${RAW_DRIVER_CORES:="*"}

# Size of the RAW cache that will trigger a GC
: ${RAW_CACHE_GC_THRESHOLD:="10GB"}

# Encryption key for Credentials service
: ${RAW_CREDS_JDBC_ENCRYPTION_KEY:=""}



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
# All source path have to be absolute paths here, as Spark does not allow
# relative ones.
: ${EXECUTOR_JAVA_OPTS:="
    ${SPARK_PORT}
    -Draw.executor.spark.docker-driver.volumes.0=$(pwd)/conf/raw-driver/logback.xml:/opt/docker/conf/logback.xml:ro
    -Draw.executor.spark.docker-driver.volumes.1=$(pwd)/conf/raw-driver/core-site.xml:/opt/docker/conf/core-site.xml:ro
    -Draw.executor.spark.docker-driver.volumes.2=${COMPOSE_PROJECT_NAME}_cache:/var/tmp/rawcache
    -Draw.executor.spark.docker-driver.volumes.3=${COMPOSE_PROJECT_NAME}_data:${RAW_DATA_TARGET}:ro
    -Draw.executor.spark.docker-driver.volumes.4=${COMPOSE_PROJECT_NAME}_logs_driver:/var/log/raw
    -Draw.executor.spark.docker-driver.image-name=${DOCKER_REGISTRY}/raw-driver-docker-compose
"}

: ${CREDS_JAVA_OPTS:=""}
: ${STORAGE_JAVA_OPTS:=""}
: ${FRONTEND_JAVA_OPTS:=""}
