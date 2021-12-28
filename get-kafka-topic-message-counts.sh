#!/bin/bash
#usage bash get-kafka-topic-message-counts.sh <topic-name> <timestamp>
echo "Topic:Partition:Offset:Count"
for i in $(kubectl exec -it kafka-0 -c kafka -- bash -c "kafka-run-class kafka.tools.GetOffsetShell --broker-list kafka-0:9093 --time $2 --topic $1")
do
  topic=$(echo $i|cut -d ":" -f 1)
  partition=$(echo $i|cut -d ":" -f 2)
  offset=$(echo $i|cut -d ":" -f 3|tr -d '\r \n')
  echo "$topic:$offset:$partition:$(kubectl exec -it kafka-0 -c kafka -- bash -c "kafka-console-consumer --offset $offset --bootstrap-server kafka-0:9093 --topic $topic --partition $partition --timeout-ms 2000 2>/dev/null | wc -l ")"
done
