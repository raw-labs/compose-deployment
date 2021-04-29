# Running RAW with Docker Compose

This repository contains the scripts and configuration to run the Docker Compose version of RAW.

## System Requirements

- Docker
- Docker Compose
- OpenSSL
- Python 3

The installation has been tested on Ubuntu 20.04 and CentOS 8 (with Docker CE instead of CentOS/RHEL podman).

### Known Issues

* *CentOS/RHEL:* On CentOS/RHEL, make sure you are using Docker CE, not podman, as there are incompatibility issues between podman and Docker Compose.
* *macOs:* On macOS, when launching RAW for the first time you may be prompted to grant permissions to RAW to access directories. This is expected as RAW requires write access to the directory where it is installed.

## Quick Start

1. [Contact us](https://www.raw-labs.com/contact-us/) to obtain the license file and username/password for the RAW Docker Registry.
2. Download or clone this repository.
3. Save the license file under `conf/raw.license`. Alternatively, define the environment variable `RAW_LICENSE` pointing to the license file.
4. Login to the docker registry using the username/password provided by running:
```sh
docker login artifactory.raw-labs.com/compose
```
5. Start RAW:
```sh
./run.sh up
```
6. Point your browser to [http://localhost:8888/notebooks/Introduction.ipynb](http://localhost:8888/notebooks/Introduction.ipynb) to follow our tutorial using Jupyter Notebooks.
7. (Optional) To access the RAW Web Administration UI, go to [http://localhost:9000](http://localhost:9000). A video tutorial on the RAW Web Administration UI is available [here](https://www.youtube.com/playlist?list=PLS9s46JylP7G39cAk8kDEwFOJcT6q29qD).

## Report an Issue

Use [support@raw-labs.atlassian.net](mailto:support@raw-labs.atlassian.net) to report an issue or give us feedback.

## Additional Configuration

### Ports

The default configuration opens a set of service ports which are accessible over the network: the default configuration does not include any form of security.

By default, the following ports are exposed:
 * raw-executor: `54321`
 * raw-creds: `54322`
 * raw-storage: `54323`
 * raw-frontend: `9000`
 * raw-jupyter: `8888`

### Credentials

The Credentials service requires a secret AES symmetric key in order to encrypt any  credentials stored in the underlying database. This will be generated automatically the first time you run RAW, but requires OpenSSL to be installed in your machine.

(RAW does not require a credentials database but this is included in this local version for ease-of-use.)

### [Optional] TLS Proxy

In order to use the TLS proxy, you will need to provide certificates for your server public address under:

 * `conf/certs/proxy.crt`
 * `conf/certs/proxy.key`

and add this to your `settings.local.sh`:

```sh
: ${COMPOSE_FILE:="docker-compose-proxy.yml"}
: ${PUBLIC_ADDRESS:="public address of the server"}
```

This will start: raw-executor, raw-creds, raw-storage and raw-frontend but only expose the following ports:

 * proxy on `80`
 * proxy on `443`

with an automatic redirection to HTTPS on port `443`. The endpoints will be setup as follows:

 * raw-executor: `https://${PUBLIC_ADDRESS}:443/api/executor`
 * raw-creds: `https://${PUBLIC_ADDRESS}:443/api/creds`
 * raw-storage: `https://${PUBLIC_ADDRESS}:443/api/storage`
 * raw-frontend: `https://${PUBLIC_ADDRESS}:443/` 

**Atention:** raw-jupyter is not started with the proxy deployment.

### [Optional] Auth0 user authentication

One of the authentication system supported is **Auth0**. To use is you will need to add in your `settings.local.sh` file:

```sh
: ${AUTH_CONF:="./conf/auth-your-config.conf"} 
```

And copy `conf/auth-auth0.conf` to `conf/auth-auth0-your-config.conf` and fill in the different values contained in the file.

**Note:** This has only been tested with the TLS proxy configuration enabled.

## Managing RAW services

The `run.sh` script includes a wrapper around Docker Compose.

In order to manage the RAW services, use `run.sh <docker-compose commands>`. For example:

 * Start and stay attached to the services consoles:
   1. `./run.sh up`
   2. Type **CTRL+C** to stop the containers.
 * Alternatively, start the services in the background:
   1. : `./run.sh up -d`
   2. To stop the services: `./run.sh stop`
 * To restart the services after a stop: `./run.sh start`
 * To stop and delete the containers: 
   * `./run.sh down`, or 
   * `./run.sh down --volumes` to remove all the docker volumes as well.

For more information, please check the **docker-compose** documentation.

Once RAW services have started:
* To use Jupyter Notebooks with RAW, go to [http://localhost:8888](http://localhost:8888). 
* To access the RAW Web Administration UI, go to [http://localhost:9000](http://localhost:9000) (or `http://${PUBLIC_ADDRESS}` if you configured the proxy).

### Configuring memory, cores and cache limits

The following environment variables can be set to control the memory and number of cores used by RAW. These values are applied per user session:
- `RAW_DRIVER_MEM` - Maximum heap size. Default value is `8g`.
- `RAW_DRIVER_CORES` - Number of cores used. Default value is the number of cores available.
- `RAW_CACHE_GC_THRESHOLD` - The size of the cache that when reached will trigger a garbage collection. Default value is `10GB`.

### Logs

The logs are stored in the current working directory, under  `./logs`.
This directory contains a subdirectory for each process, e.g., `./logs/executor`, `./logs/driver`, and so on.

The logs from the previous run are deleted when launching RAW.

### Changing settings

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

The configuration is in the `conf/` subdirectory, organized by RAW service (frontend, credentials service, executor service, storage service).

The configuration of the driver, responsible for running a user session, is handled differently because the driver is launched at runtime by RAW.

The JVM options used to launch the driver are set in `conf/raw-executor/driver-java-options`. In principle, there is no need to change these options.
