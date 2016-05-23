#!/usr/bin/env bash

# Stop all docker containers
docker rm -f $(docker ps -a -q)

# Remove orphaned docker images "none"
docker rmi $(docker images -a | awk '/\<none\>/ { print $3 }')

# This script needs to run in config-dir only.
echo Directory : ${PWD}

# Delete old log file if exists.
LOG_FILE=logstash.log
echo Log file : ${LOG_FILE} - `[ -f ${LOG_FILE} ] && { echo -n " FOUND... " ; rm ${LOG_FILE} && echo Deleted. ; } || echo NOT FOUND.`

# Check configuration file.
CONF_NAME=${1}
CONF_FILE=logstash-${CONF_NAME}.conf
echo Configuration file : ${CONF_FILE} - `[ -f ${CONF_FILE} ] && echo FOUND || { echo NOT FOUND. ABORTING! ; exit 1 ; }`

# Set up mode how to run docker : Interactive or Detached.
DOCKER_RUN_AS_INTERACTIVE="-it --rm"
DOCKER_RUN_AS_DETACHED="-d"
DOCKER_RUN_AS=`[ ${CONF_NAME} == "stdin-to-stdout" ] && { echo ${DOCKER_RUN_AS_INTERACTIVE} ; } || echo ${DOCKER_RUN_AS_DETACHED}`
echo Docker run as : ${DOCKER_RUN_AS}

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

