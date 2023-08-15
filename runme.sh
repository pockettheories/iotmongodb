#!/usr/bin/env bash
docker run --name iotInsert -it -e mongouri='mongodb://host.docker.internal:27017' -e dbname='iot' -e collname='meter_readings' -e bucketsize=10 -e sleeptime=2 -e demomode=advanced iotinsert
