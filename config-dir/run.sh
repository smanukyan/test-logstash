#!/usr/bin/env bash

# This script needs to run in config-dir only.
echo Directory : ${PWD}

# Delete old log file if exists.
LOG_FILE=logstash.log
echo Log file : ${LOG_FILE} - `[ -f ${LOG_FILE} ] && { echo -n " FOUND... " ; rm ${LOG_FILE} && echo Deleted. ; } || echo NOT FOUND.`

# Check configuration file.
CONF_NAME=${1}
CONF_FILE=logstash-${CONF_NAME}.conf
echo Configuration file : ${CONF_FILE} - `[ -f ${CONF_FILE} ] && echo FOUND || { echo NOT FOUND. ABORTING! ; exit 1 ; }`

touch output.log

echo Starting docker...
docker run \
    -it --rm \
    -v "${PWD}":/config-dir \
    logstash \
        logstash \
        --debug \
        -f /config-dir/${CONF_FILE} \
        -l /config-dir/${LOG_FILE}

