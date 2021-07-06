#!/bin/sh
# shellcheck disable=SC1090,SC1091,SC2013,SC2086

# The MIT License (MIT)
#
# Copyright (c) 2021 Data Intensive Applications and Systems Laboratory (DIAS)
#                    Ecole Polytechnique Federale de Lausanne
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if test ! -d "${SCRIPT_DIR}"
then
    echo "SCRIPT_DIR is unset or does not point to a folder."
    exit 1
fi

# Settings are taken in the following order of precedence:
#  1. Shell Environment, or on the command line

#  2. Deployment-specific `settings.local.sh`
if test -f ${SCRIPT_DIR}/settings.local.sh
then
	. ${SCRIPT_DIR}/settings.local.sh
fi

# checking if a encryption key for creds server exists, if not create a new one
if [ -z "${RAW_CREDS_JDBC_ENCRYPTION_KEY}" ]
then
  if openssl help 2> /dev/null
  then
    echo "Generating credentials server encryption key and saving it in settings.local.sh"
    RAW_CREDS_JDBC_ENCRYPTION_KEY=$(openssl rand -base64 32)
    export RAW_CREDS_JDBC_ENCRYPTION_KEY
    printf  "\n: \${RAW_CREDS_JDBC_ENCRYPTION_KEY:=\"%s\"}" "$RAW_CREDS_JDBC_ENCRYPTION_KEY">> settings.local.sh
  else
    echo "Could not find OpenSSL, which is required to generate a server encryption key. Please install 'openssl' and try again."
    exit 1
  fi
fi


# If settings.local.sh does not define RAW_DRIVER_CORES, add a default value computed based on the total number of cores of the current system.
if [ -z "${RAW_DRIVER_CORES}" ]
then
    SYSTEM_CORES=$(grep 'cpu cores' /proc/cpuinfo | head -n 1 | awk '{print $4}')
    if [ "$SYSTEM_CORES" -le 2 ]
    then
        RAW_DRIVER_CORES=1
    elif [ "$SYSTEM_CORES" -le 4 ]
    then
        RAW_DRIVER_CORES=2
    else
        RAW_DRIVER_CORES=$(( SYSTEM_CORES-2 ))
    fi
    export RAW_DRIVER_CORES
    printf  "\n: \${RAW_DRIVER_CORES:=\"%s\"}" "$RAW_DRIVER_CORES">> settings.local.sh
fi


# If settings.local.sh does not define RAW_DRIVER_MEM, add a default value computed based on the total system memory.
if [ -z "${RAW_DRIVER_MEM}" ]
then
    SYSTEM_MEMORY_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    SYSTEM_MEMORY_GB=$(( SYSTEM_MEMORY_KB / 1024 / 1024 ))
    if [ "$SYSTEM_MEMORY_GB" -le 4 ]
    then
        RAW_DRIVER_MEM=1
    else
        RAW_DRIVER_MEM=$(( SYSTEM_MEMORY_GB / 2 ))
    fi
    if [ "$RAW_DRIVER_MEM" -ge 31 ]
    then
        RAW_DRIVER_MEM=31
    fi
    RAW_DRIVER_MEM="$RAW_DRIVER_MEM"g
    export RAW_DRIVER_MEM
    printf  "\n: \${RAW_DRIVER_MEM:=\"%s\"}" "$RAW_DRIVER_MEM">> settings.local.sh
fi

# If settings.local.sh does not define RAW_CACHE_GC_THRESHOLD, add a default value computed based on available disk space
if [ -z "${RAW_CACHE_GC_THRESHOLD}" ]
then
    FREE_DISK_KB=$(df -Pk ${RAW_CACHE:-$SCRIPT_DIR} | tail -n 1 | awk '{print $4}')
    FREE_DISK_GB=$(( FREE_DISK_KB / 1024 / 1024 ))
    if [ "$FREE_DISK_GB" -le 4 ]
    then
        RAW_CACHE_GC_THRESHOLD=1
    else
        RAW_CACHE_GC_THRESHOLD=$(( FREE_DISK_GB / 2 ))
    fi
    if [ "$RAW_CACHE_GC_THRESHOLD" -ge 30 ]
    then
        RAW_CACHE_GC_THRESHOLD=30
    fi
    export RAW_CACHE_GC_THRESHOLD
    printf  "\n: \${RAW_CACHE_GC_THRESHOLD:=\"%s\"}" "$RAW_CACHE_GC_THRESHOLD">> settings.local.sh
fi



#  4. Default settings `settings.default.sh`
. ${SCRIPT_DIR}/settings.default.sh

if ${SHOW_SETTINGS}
then
	echo "Current settings:"
fi

for v in $(grep '^:' settings.default.sh|cut -c 5- |cut -d: -f1)
do
	eval "export $v=\"\$$v\""
	if ${SHOW_SETTINGS}
	then
		eval "echo $v=\$$v"
	fi
done

if ${SHOW_SETTINGS}
then
	echo
fi
