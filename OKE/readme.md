# Spin up a Managed Kubernetes cluster with all required networking objects #

## Prerequisites: ##

- Installed terraform on your local machine
- OCI account with OKE available
- a policy statement "allow service OKE to manage all-resources in tenancy" on the level of the root compartment
- an API (non-SSO) user with an API key

## Info required to enable the script for your environment: ##
- Tenancy OCID
- Compartiment OCID
- User OCID
- API Key fingerprint
- Private key API local path
- Region name

## Steps to execute ##

- Clone this repository locally
- Edit the file terraform.tfvars and enter your instance OCID's on the first lines
- run terraform init in this directory, all dependencies, including oci v3 should download
- run terraform plan to validate your config
- run terraform apply to spin up your infrastructure
- validate the resulting K8S infrastructure :
   - export KUBECONFIG=./mykubeconfig
   - kubeconfig version

## Improvement plans ##
- creation of OKE dedicated compartment
- add nginx ingress 
