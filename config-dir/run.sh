#!/usr/bin/env bash

# Usage :
# ./run.sh stdin-to-stdout
# ./run.sh file-to-stdout
# ./run.sh file-to-file

# This script needs to be run from config-dir folder only.
echo -n "Current directory : ${PWD} - "
if [ "${PWD##*/}" = "config-dir" ]
then
    echo OK.
else
    echo FAIL.
    echo Must run this script from config-dir folder. ABORTING!
    exit 1
fi

# Check configuration file.
CONF_NAME=${1}
CONF_FILE=logstash-${CONF_NAME}.conf
echo -n "Configuration file : ${CONF_FILE} - "
if [ -f ${CONF_FILE} ]
then
    echo FOUND.
else
    echo NOT FOUND. ABORTING!
    exit 1
fi

# Delete old log file if exists.
LOG_FILE=logstash-${CONF_NAME}.log
echo Log file : ${LOG_FILE} - `[ -f ${LOG_FILE} ] && { echo -n " FOUND... " ; rm ${LOG_FILE} && echo Deleted. ; } || echo NOT FOUND.`

echo Starting docker...
docker run \
    -it --rm \
    -v "${PWD}":/config-dir \
    logstash \
        logstash \
        --debug \
        -f /config-dir/${CONF_FILE} \
        -l /config-dir/${LOG_FILE}

