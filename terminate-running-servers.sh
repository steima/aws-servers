#!/bin/bash

set +x

cat .running-instances | while read INSTANCE_ID ; do
    echo "Terminating instance: ${INSTANCE_ID}"
    aws ec2 terminate-instances --instance-ids "${INSTANCE_ID}"
done

rm .running-instances