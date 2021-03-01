# Running RAW with Docker Compose.

This repository contains the scripts and configuration to run RAW using Docker Compose.

## Pre-requisites

- docker 
- docker-compose 

## Setting up

First download or clone this repository.

Then contact us to obtain the following:
- A license file. 
- A version number of RAW
- The credentials for the RAW Docker registry.

The license file should be copied to `/etc/raw-common/raw.license`.

Edit the file `raw-config.sh` and set the variable `RAW_VERSION` to the version of RAW that you received from us.

Finally, login to the docker registry with the following command `docker login artifactory.raw-labs.com/compose` and type the username and password that you received from us.


##  Runing

Run `start.sh` to launch the docker containers with RAW. 
The first time that is launched, the script will download the docker images. Afterwards, it will reuse the images present locally.

The docker containers will expose the following ports:

- raw-executor: 54321
- raw-creds: 54322
- raw-storage: 54323
- raw-frontend: 9000

To access the frontend, open a browser and go to "localhost:9000". 


## Logs

The logs of the drivers can be found in the host directory `/tmp/raw-driver-logs`. 
This directory is mapped to the docker container running the driver.
