#!/bin/bash

set +x

function check_ssh {
    ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -q "${1}" exit
    return $?
}

function wait_for_ssh {
    check_ssh "${1}"
    while [ $? -ne 0 ]; do
        check_ssh "${1}"
    done
}

function execute_ssh {
    SERVER="${1}"
    CMD="${2}"
    ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null "${SERVER}" "${CMD}"
}

function scp_file {
    FILE="${1}"
    SERVER="${2}"
    REMOTE_PATH="${3}"
    scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null "${FILE}" "${SERVER}:${REMOTE_PATH}"
}

# ami-1a962263 -- Amazon Linux 2017.09.1 (HVM, SSD)

aws ec2 run-instances --image-id ami-1a962263 --count 1 --instance-type t2.nano --key-name ssh-matthias-mbp --security-group-ids "will-it-scale-sg" > .instance-info
export INSTANCE_ID=$(jq -r .Instances[0].InstanceId .instance-info)
export PRIVATE_IP=$(jq -r .Instances[0].NetworkInterfaces[0].PrivateIpAddress .instance-info)
export PRIVATE_DNS=$(jq -r .Instances[0].NetworkInterfaces[0].PrivateDnsName .instance-info)

INSTANCE_STATE="undefined"
while [ "${INSTANCE_STATE}" != "running" ] ; do
    aws ec2 describe-instances --instance-ids "${INSTANCE_ID}" > .instance-detail-info
    export INSTANCE_STATE=$(jq -r .Reservations[0].Instances[0].State.Name .instance-detail-info)
    export PUBLIC_IP=$(jq -r .Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp .instance-detail-info)
    export PUBLIC_DNS=$(jq -r .Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName .instance-detail-info)
    if [ "${INSTANCE_STATE}" != "running" ] ; then
        sleep 10
    fi
done
echo "Server ${PUBLIC_DNS} up and running"

echo "${INSTANCE_ID}" >> .running-instances