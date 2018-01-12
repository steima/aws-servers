#!/bin/bash

set +x

function die {
	echo >&2 "$@"
	exit 1
}

[ "$#" -eq 1 ] || die "usage: ${0} <puppet-manifest>"

PUPPET_MANIFEST="${1}"

# create server
source ./create-server.sh
wait_for_ssh "${PUBLIC_DNS}"

# install puppet
execute_ssh "${PUBLIC_DNS}" "sudo yum -y install puppet"

# upload manifests
execute_ssh "${PUBLIC_DNS}" "mkdir -p /home/ec2-user/puppet"
scp_file classes.pp "${PUBLIC_DNS}" /home/ec2-user/puppet/
scp_file "${PUPPET_MANIFEST}" "${PUBLIC_DNS}" /home/ec2-user/puppet/

# apply manifest
execute_ssh "${PUBLIC_DNS}" "sudo puppet apply /home/ec2-user/puppet/${PUPPET_MANIFEST}"