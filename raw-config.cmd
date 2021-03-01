set DOCKER_REGISTRY=artifactory.raw-labs.com/compose
REM set RAW_STORAGE_SERVER_BASE_PATH=/var/tmp/rawcache
set RAW_STORAGE_SERVER_BASE_PATH=C:\Windows\Temp\rawcache
set JAVA_OPTS=

REM even though this option is given to the RAW Executor, the path should be relative to the host
REM because it will be used to launch the container with the driver using the Docker daemon that runs
REM on the host.
set EXECUTOR_JAVA_OPTS=^
    -Draw.executor.spark.docker-driver.volumes.0=%CD%\conf\raw-driver\logback.xml:/opt/docker/conf/logback.xml:ro ^
    -Draw.executor.spark.docker-driver.volumes.1=raw_cache:%RAW_STORAGE_SERVER_BASE_PATH% ^
    -Draw.executor.spark.docker-driver.volumes.2=%CD%\conf\raw-driver\core-site.xml:/opt/docker/conf/core-site.xml ^
    -Draw.executor.spark.docker-driver.ports.0=4040:4040 ^
    -Draw.executor.spark.docker-driver.image-name=%DOCKER_REGISTRY%/raw-driver-docker-compose

set CREDS_JAVA_OPTS=
set STORAGE_JAVA_OPTS=
set FRONTEND_JAVA_OPTS=
set RAW_VERSION=CONTACT_US
set PUBLIC_ADDRESS=localhost
