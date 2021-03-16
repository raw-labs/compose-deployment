cd %~dp0

docker-compose -f docker-compose.yml rm -f postgres raw-storage raw-creds raw-executor raw-frontend

docker pull %DOCKER_REGISTRY%/raw-driver-docker-compose:%RAW_VERSION%

docker-compose -f docker-compose.yml up
