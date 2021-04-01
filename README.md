# Running RAW with Docker Compose.

This repository contains the scripts and configuration to run RAW using Docker Compose.


## Pre-requisites

- docker
- docker-compose


## Setting up

First download or clone this repository.

Then [contact us](https://www.raw-labs.com/contact-us/) to obtain the following:
- A license file
- A version number of RAW
- The credentials for the RAW Docker registry

The license file should be copied to the following location: `conf/raw.license`, or `RAW_LICENSE` pointed to the file (see [below](#Settings) how to change settings).

Create a file named `settings.local.sh`, with the following:

```sh
: ${RAW_VERSION:="The version number you received from us"}
```

Finally, login to the docker registry with the following command `docker login artifactory.raw-labs.com/compose` and type the username and password that you received from us.

**Note:** The following sections will assume the default values are used for the settings, adapt as needed if you make modifications.


### Basic setup

By default we expose the following RAW services:

 * raw-executor: `54321`
 * raw-creds: `54322`
 * raw-storage: `54323`
 * raw-frontend: `9000`

Please keep in mind these ports will be accessible from the machine as well as any computer which can connect to your computer, and unless you setup some authentication, **without any credentials**.

If you add files in the `data` sub directory, these will be visible within RAW under `file:/data`


### [Optional] TLS Proxy

In order to use the TLS proxy, you will need to provide certificates for your server public address under:

 * `conf/certs/proxy.crt`
 * `conf/certs/proxy.key`

and add this to your `settings.local.sh`:

```sh
: ${COMPOSE_FILE:="docker-compose-proxy.yml"}
: ${PUBLIC_ADDRESS:="public address of the server"}
```

This will start all the services required, but only expose the following ports:

 * proxy on `80`
 * proxy on `443`

with an automatique redirection to HTTPS on port `443`. The endpoints will be setup as follows:

 * raw-executor: `https://${PUBLIC_ADDRESS}:443/api/executor`
 * raw-creds: `https://${PUBLIC_ADDRESS}:443/api/creds`
 * raw-storage: `https://${PUBLIC_ADDRESS}:443/api/storage`
 * raw-frontend: `https://${PUBLIC_ADDRESS}:443/` 


### [Optional] Auth0 user authentication

One of the authentication system supported is **Auth0**. To use is you will need to add in your `settings.local.sh` file:

```sh
: ${AUTH_CONF:="./conf/auth-your-config.conf"} 
```

And copy `conf/auth-auth0.conf` to `conf/auth-auth0-your-config.conf` and fill in the different values contained in the file.

**Note:** This has only been tested with the TLS proxy configuration enabled.


## Running

In order to manage the RAW services, use `run.sh <docker-compose commands>`.

For example:

 * Start and stay attached to the services consoles:
   1. `./run.sh up`
   2. Type **ctrl+c** to stop the containers
 * Start the services
   1. in the background: `./run.sh up -d`
   2. To stop the services: `./run.sh stop`
 * To restart the services after a stop: `./run.sh start`
 * To stop and delete the containers: 
   * `./run.sh down`, or 
   * `./run.sh down --volumes` to remove all the docker volumes as well.

For more information, please check the **docker-compose** documentation.

To access the frontend, open a browser and go to [http://localhost:9000](http://localhost:9000) or `http://${PUBLIC_ADDRESS}` if you configured the proxy.

### Configuration

For convenience, the following environment variables can be set to control the memory and number of cores 
used by the system. These values are applied per user session:
- `RAW_DRIVER_MEM` - Maximum heap size. Example value is `8g`.
- `RAW_DRIVER_CORES` - Number of cores used.

## Logs

The logs of the drivers can be found in the host directory `/tmp/raw-driver-logs`.
This directory is mapped to the docker container running the driver.


## Configuration

All the settings have default values, but you can change them by either exporting in your shell the setting with its value, or creating `settings.local.sh` in the same folder as `settings.sh`:

```sh
: ${VARIABLE:="Your value"}
```

**Note:** To find the exhaustive list of parameters available please take a look at `settings.default.sh`.

Settings are taken in the following order of precedence:

  1. On the command line (`VARIABLE="Your Value" ./run.sh`)
  2. Shell environment
  3. Deployment-specific `settings.local.sh`
  4. Default settings `settings.default.sh`

### Configuration of services

The configuration is in the `conf/` subdirectory, organized by RAW service (frontend, credentials service, executor service, storage service).

The configuration of the driver, responsible for running a user session, is a special case, because the driver is launched at runtime by the RAW Executor.
The JVM options used to launch the driver are set in `conf/raw-executor/driver-java-options`. In principle, there is no need to change these options.

## Report an Issue

Report an issue [here](mailto:support@raw-labs.atlassian.net).
