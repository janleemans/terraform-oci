# Create required network config for a Managed Kubernetes cluster #

## Prerequisites: ##

- Installed terraform on your local machine
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
- validate the resulting network via your console
