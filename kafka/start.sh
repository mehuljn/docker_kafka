#!/bin/bash -x

[ -n "$ZOOKEEPER_PORT_2181_TCP_ADDR" ] && ZOOKEEPER_IP=$ZOOKEEPER_PORT_2181_TCP_ADDR
[ -n "$ZOOKEEPER_PORT_2181_TCP_PORT" ] && ZOOKEEPER_PORT=$ZOOKEEPER_PORT_2181_TCP_PORT

IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')
JMX_PORT1=7203
JMX_PORT2=7204

[ -z "$ZOOKEEPER_CONNECTION_STRING" ] && ZOOKEEPER_CONNECTION_STRING="${ZOOKEEPER_IP}:${ZOOKEEPER_PORT:-2181}"

cat /kafka/config/server.properties.template | sed \
  -e "s|{{ZOOKEEPER_CONNECTION_STRING}}|${ZOOKEEPER_CONNECTION_STRING}|g" \
  -e "s|{{ZOOKEEPER_CHROOT}}|${ZOOKEEPER_CHROOT:-}|g" \
  -e "s|{{KAFKA_BROKER_ID}}|${KAFKA_BROKER_ID:-0}|g" \
  -e "s|{{KAFKA_ADVERTISED_HOST_NAME}}|${KAFKA_ADVERTISED_HOST_NAME:-$IP}|g" \
  -e "s|{{KAFKA_PORT}}|${KAFKA_PORT:-9092}|g" \
  -e "s|{{KAFKA_ADVERTISED_PORT}}|${KAFKA_ADVERTISED_PORT:-9092}|g" \
  -e "s|{{KAFKA_DELETE_TOPIC_ENABLE}}|${KAFKA_DELETE_TOPIC_ENABLE:-false}|g" \
  -e "s|{{ZOOKEEPER_CONNECTION_TIMEOUT_MS}}|${ZOOKEEPER_CONNECTION_TIMEOUT_MS:-10000}|g" \
  -e "s|{{ZOOKEEPER_SESSION_TIMEOUT_MS}}|${ZOOKEEPER_SESSION_TIMEOUT_MS:-10000}|g" \
  -e "s|{{GROUP_MAX_SESSION_TIMEOUT_MS}}|${GROUP_MAX_SESSION_TIMEOUT_MS:-300000}|g" \
  -e "s|{{KAFKA_METRICS_GRAPHITE_HOST}}|${KAFKA_METRICS_GRAPHITE_HOST}|g" \
  -e "s|{{KAFKA_METRICS_GRAPHITE_PORT}}|${KAFKA_METRICS_GRAPHITE_PORT}|g" \
   > /kafka/config/server.properties

if [ -z $KAFKA_JMX_OPTS ]; then
    KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.ssl=false"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT1"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT2"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.local.only=false"
    KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Djava.rmi.server.hostname=${JAVA_RMI_SERVER_HOSTNAME:-$KAFKA_ADVERTISED_HOST_NAME} "
    export KAFKA_JMX_OPTS
fi

echo "Starting kafka"
exec /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
