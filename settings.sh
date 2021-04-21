#!/bin/sh
# shellcheck disable=SC1090,SC2013,SC2086

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
    export RAW_CREDS_JDBC_ENCRYPTION_KEY=$(openssl rand -base64 32)
    printf  "\n: \${RAW_CREDS_JDBC_ENCRYPTION_KEY:=\"%s\"}" "$RAW_CREDS_JDBC_ENCRYPTION_KEY">> settings.local.sh
  else
    echo "Could not find openssl to generate credentials server encryption key."
    echo "If you are in a Linux system try installing it with your distributions package manager eg.: apt or yum"
    echo "If are using MacOs or Windows try searching for installation files for your operative system."
    exit 1
  fi
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
