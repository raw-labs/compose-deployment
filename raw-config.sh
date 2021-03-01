export DOCKER_REGISTRY="artifactory.raw-labs.com/compose"
export RAW_STORAGE_SERVER_BASE_PATH="/var/tmp/rawcache"
export JAVA_OPTS=""

# even though this option is given to the RAW Executor, the path should be relative to the host
# because it will be used to launch the container with the driver using the Docker daemon that runs
# on the host.
export EXECUTOR_JAVA_OPTS="
    -Draw.executor.spark.docker-driver.volumes.0=$(pwd)/conf/raw-driver/logback.xml:/opt/docker/conf/logback.xml:ro
    -Draw.executor.spark.docker-driver.volumes.1=raw_cache:${RAW_STORAGE_SERVER_BASE_PATH}
    -Draw.executor.spark.docker-driver.volumes.2=$(pwd)/conf/raw-driver/core-site.xml:/opt/docker/conf/core-site.xml
    -Draw.executor.spark.docker-driver.ports.0=4040:4040
    -Draw.executor.spark.docker-driver.image-name=${DOCKER_REGISTRY}/raw-driver-docker-compose"

export CREDS_JAVA_OPTS=""
export STORAGE_JAVA_OPTS=""
export FRONTEND_JAVA_OPTS=""

export RAW_VERSION="<CONTACT US>"
export PUBLIC_ADDRESS="localhost"
