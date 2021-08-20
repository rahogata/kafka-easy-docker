#!/bin/bash

set -eux

for t in "$@" ; do
    docker-compose exec -T kafka /opt/kafka_2.12-2.5.1/bin/kafka-topics.sh --bootstrap-server 192.168.1.101:9092 --create --topic "$t"
done

