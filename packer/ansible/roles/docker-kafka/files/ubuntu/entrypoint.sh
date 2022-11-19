#!/bin/bash

# init environment variables
NODE_ID=${HOSTNAME:6}

if [ ${HOSTNAME:0:5} != "kafka" ]; then
  export NODE_ID=0
fi

[ -f ${SHOW_ENV_VARS+1} ] && SHOW_ENV_VARS=1
[ -f ${SHARE_DIR+1} ] && SHARE_DIR="/mnt/kafka"
[ -f ${SERVICE+1} ] && SERVICE="kafka-service"
[ -f ${NAMESPACE+1} ] && NAMESPACE="kafka"
[ -f ${REPLICAS+1} ] && REPLICAS=3
[ -f ${LOG_RETENTION_HOURS+1} ] && LOG_RETENTION_HOURS=4
[ -f ${REPLICATION_FACTOR+1} ] && REPLICATION_FACTOR=1
[ -f ${KAFKA_HEAP_OPTS+1} ] && KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
[ -f ${KAFKA_OPTS+1} ] && KAFKA_OPTS="-Djava.net.preferIPv4Stack=True"

LISTENERS="PLAINTEXT://:9092,CONTROLLER://:9093"
ADVERTISED_LISTENERS="PLAINTEXT://kafka-${NODE_ID}.${SERVICE}.${NAMESPACE}.svc.cluster.local:9092"

CONTROLLER_QUORUM_VOTERS=""
for i in $( seq 0 $REPLICAS); do
    if [[ $i != $REPLICAS ]]; then
        CONTROLLER_QUORUM_VOTERS="$CONTROLLER_QUORUM_VOTERS$i@kafka-$i.${SERVICE}.${NAMESPACE}.svc.cluster.local:9093,"
    else
        CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}
    fi
done

mkdir -p ${SHARE_DIR}/${NODE_ID}

if [[ ! -f "${SHARE_DIR}/cluster_id" && "${NODE_ID}" = "0" ]]; then
    CLUSTER_ID=$(kafka-storage.sh random-uuid)
    echo ${CLUSTER_ID} > ${SHARE_DIR}/cluster_id
else
    CLUSTER_ID=$(cat ${SHARE_DIR}/cluster_id)
fi

if [ ${SHOW_ENV_VARS} == 1 ]; then
  echo "USER_INFO: $(id)"
  echo "HOSTNAME: ${HOSTNAME}"
  echo "NODE_ID: ${NODE_ID}"
  echo "SERVICE: ${SERVICE}"
  echo "NAMESPACE: ${NAMESPACE}"
  echo "REPLICAS: ${REPLICAS}"
  echo "LOG_RETENTION_HOURS: ${LOG_RETENTION_HOURS}"
  echo "REPLICATION_FACTOR: ${REPLICATION_FACTOR}"
  echo "CONTROLLER_QUORUM_VOTERS: ${CONTROLLER_QUORUM_VOTERS}"
  echo "SHARE_DIR: ${SHARE_DIR}"
  echo "CLUSTER_ID: ${CLUSTER_ID}"
  echo "KAFKA_HOME: ${KAFKA_HOME}"
  echo "KAFKA_VERSION: ${KAFKA_VERSION}"
  echo "KAFKA_CONFIG: ${KAFKA_CONFIG}"
  echo "KAFKA_HEAP_OPTS: ${KAFKA_HEAP_OPTS}"
  echo "KAFKA_OPTS: ${KAFKA_OPTS}"
fi

sed -e "s+^node.id=.*+node.id=${NODE_ID}+" \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=${CONTROLLER_QUORUM_VOTERS}+" \
-e "s+^listeners=.*+listeners=${LISTENERS}+" \
-e "s+^advertised.listeners=.*+advertised.listeners=${ADVERTISED_LISTENERS}+" \
-e "s+^log.dirs=.*+log.dirs=${SHARE_DIR}/${NODE_ID}+" \
${KAFKA_CONFIG} > server.properties.updated \
&& mv server.properties.updated ${KAFKA_CONFIG}

sleep 1
kafka-storage.sh format -t $CLUSTER_ID -c ${KAFKA_CONFIG}

if [ ${NODE_ID} != 0 ]; then
  sleep 20
fi

exec kafka-server-start.sh ${KAFKA_CONFIG}