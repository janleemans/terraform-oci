# terraform-oci #
Build Oracle OCI environments with Terraform

This repository contains simple and easy-to-use examples of configurations on Oracle Cloud that can be spun up using Terraform.

Just fork the repossitory, change your connection parameters and you have a Managed Kubernetes cluster with the corresponding kubeconfig file in a few minutes!

Terraform scripts have been copied / inspired from / simplified from [the Hashicorp documentation & Examples repository](https://github.com/terraform-providers/terraform-provider-oci/tree/master/docs) and using the [Terraform documentation for OCI](https://www.terraform.io/docs/providers/oci/index.html)


## Scripts in this repository ##

This is the v1 of this repository, currently just one object: Managed Kubernetes cluster

- Spin up a managed kubernetes cluster, with all required network objects (VNC, Subnets, security lists, etc.)
