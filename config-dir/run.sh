#!/usr/bin/env bash

# Before running this script make sure you cd into config-dir folder.

rm logstash.log

docker run \
    -it \
    --rm \
    -v "${PWD}":/config-dir \
    logstash \
        logstash \
        --debug \
        -f /config-dir/logstash.conf \
        -l /config-dir/logstash.log
