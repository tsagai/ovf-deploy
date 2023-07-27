# ovf-deploy
Bash script that uses `govc` to deploy OVF templates (specifically Tanuz Ops Manager VMs) to VSphere

## Initial Setup
1. Make script executable
```bash
chmod +x ovfdeploy.sh
```

2. Install binary release of `govc` and `jq` 

`govc` - https://github.com/vmware/govmomi/releases

`jq` - https://github.com/stedolan/jq/releases

3. Move both binaries to an executable environmental path
```bash
sudo mv govc /usr/local/bin && sudo mv jq /usr/local/bin
```

4. Install Opsman VM from here - https://network.pivotal.io/products/ops-manager/#/releases/1154098



## Configuration
Edit the following environmental variables in the script: 

```bash
export GOVC_USERNAME=""
export GOVC_PASSWORD=""
export GOVC_URL=""
export GOVC_INSECURE=
export GOVC_DATACENTER=
export GOVC_DATASTORE=
export GOVC_NETWORK=
export GOVC_RESOURCE_POOL=
```

And 

```bash
export IP=""
export NETMASK0=""
export GATEWAY=""
export DNS=""
export NTP_SERVER=""
export PUB_SSH_KEY=""
export CUSTOM_HOSTNAME=""
export NETWORK_NAME=""
export VM_NAME=""
```

If these are not defined, the script will not work properly

## Usage
```bash
./ovfdeploy.sh /path/to/opsmanvm
```

Example: 
```bash
./ovfdeploy.sh ~/Downloads/ops-manager-vsphere-2.10.51-build.662.ova
```


