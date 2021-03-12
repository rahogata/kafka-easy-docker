# Kafka and Zookeeper

FROM openjdk:8-jre-slim-buster

ARG KAFKAC=91F96F28C016BDAA3FE025F87ACE188417A1E594C8E32B7D23A104AA390BC25F5DB5897E23CCCF00EA7EDE3AC20B3028C10363EBE99DCBD7DB2CF6237EE7553A
ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.5.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Install Kafka, Zookeeper and other needed things
RUN set -x && \
    apt-get update && \
    apt-get install -y wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget https://archive.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    echo "${KAFKAC} /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" | sha512sum -c - && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

ADD scripts/start-kafka.sh scripts/start-zookeeper.sh /usr/bin/

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]

