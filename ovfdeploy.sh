#!/bin/bash

# Reference Site: https://williamlam.com/2016/04/slick-way-of-deploying-ovfova-directly-to-esxi-vcenter-server-using-govc-cli.html

# Create spec file
if [ -z "$1" ]; then
  echo -e "Usage:\n\t${0} <OVA FILEPATH>"
  exit 1
fi

# Env variables for particular vSphere user
export GOVC_USERNAME=""
export GOVC_PASSWORD=""
export GOVC_URL=""
export GOVC_INSECURE=
export GOVC_DATACENTER=
export GOVC_DATASTORE=
export GOVC_NETWORK=
export GOVC_RESOURCE_POOL=

# Extract JSON template from OVA file
govc import.spec $1 | python3 -m json.tool > vm.json && echo "VM JSON created at: $PWD/vm.json" || echo "Something went wrong"

# Env variable for OVF template injection
export IP=""
export NETMASK0=""
export GATEWAY=""
export DNS=""
export NTP_SERVER=""
export PUB_SSH_KEY=""
export CUSTOM_HOSTNAME=""
export NETWORK_NAME=""
export VM_NAME=""

# Create final.json file with env variables above injected
jq --arg ip "$IP" \
--arg netmask "$NETMASK0" \
--arg gateway "$GATEWAY" \
--arg dns "$DNS" \
--arg ntp "$NTP_SERVER" \
--arg pub_key "$PUB_SSH_KEY" \
--arg hostname "$CUSTOM_HOSTNAME" \
--arg network_name "$NETWORK_NAME" \
--arg vm_name "$VM_NAME" \ '.DiskProvisioning="thin" | .PropertyMapping[0].Value=$ip | .PropertyMapping[1].Value=$netmask | .PropertyMapping[2].Value=$gateway | .PropertyMapping[3].Value=$dns | .PropertyMapping[4].Value=$ntp | .PropertyMapping[5].Value=$pub_key | .PropertyMapping[6].Value=$hostname | .NetworkMapping[0].Network=$network_name | .Name=$vm_name' vm.json > final.json && echo "final.json for OVF deployment has been created at: $PWD/final.json"

# Deploy OVF file using final.json
govc import.ova -options=./final.json $1
