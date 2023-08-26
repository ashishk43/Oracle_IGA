// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {
  description = "INSERT YOUR TENANCY OCID HERE"
}

variable "compartment_ocid" {
  description = "INSERT YOUR COMPARTMENT OCID HERE"
}

variable "region" {
  default = "us-ashburn-1"
}

variable "cluster_name" {
  default = "tfTestCluster"
}

variable "vcn_cidr" {
  type        = string
  description = "cidr block of VCN"
  default     = "10.180.8.0/21"
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  description = "This is the CIDR range used for IP addresses by your pods. A /16 CIDR is generally sufficient. This CIDR should not overlap with any subnet range in the VCN (it can also be outside the VCN CIDR range)."
  default     = "10.244.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  description = "This is the CIDR range used by exposed Kubernetes services (ClusterIPs). This CIDR should not overlap with the VCN CIDR range."
  default     = "10.96.0.0/16"
}

variable "node_pool_initial_node_labels_key" {
  default = "key"
}

variable "node_pool_initial_node_labels_value" {
  default = "value"
}

variable "node_pool_name" {
  default = "tfPool"
}

#variable "node_pool_node_image_name" {
#  default = "Oracle-Linux-7.6"
#}

variable "node_pool_node_shape" {
  default = "VM.StandardB1.2"
}

variable "number_of_nodes" {
  description = "Number of Worker Nodes in the Node pool"
  default     = 2
}

variable "lb_cidr" {
  type        = string
  description = "cidr block of lb"
  default     = "10.180.14.0/24"
}

variable "nodepools_cidr" {
  type        = string
  description = "cidr block of nodepools"
  default     = "10.180.15.0/24"
}

variable "worker_mode" {
  description = "whether to provision public or private workers"
  default     = "private"
}

variable "vcn_dns_label" {
  type    = string
  default = "oke"
}

variable "cluster_kube_config_expiration" {
  default = 2592000
}

variable "cluster_kube_config_token_version" {
  default = "2.0.0"
}

variable "compartment_name" {
  type        = string
  description = "compartment name"
  default     = "novalue"
}

variable "newbits" {
  type        = string
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = "8"
}

variable "subnets" {
  description = "zero-based index of the subnet when the network is masked with the newbit."
  type        = string
  default = "32"
}

variable "bastion_shape" {
  description = "shape of bastion instance"
  default     = "VM.Standard.B1.2"
}

variable "availability_domains" {
  description = "ADs where to provision non-OKE resources"
  type        = string
  default = "1"
}

variable "helm_version" {
  description = "version of helm to install"
  default     = "3.4.1"
}

variable "create_bastion" {
  default = true
}

variable "install_helm" {
  default = true
}

locals {
  mount_target_ip_address = lookup(data.oci_core_private_ips.ip_mount_target.private_ips[0], "ip_address")
}

variable "idm_cli_object_storage_url" {
  type    = string
  default = "https://objectstorage.us-ashburn-1.oraclecloud.com/n/idkgvfvqincr/b/bucket-orm-Jan2021/o/idmcli_unix"
}

variable "oig_db_url" {
  type    = string
  default = "130.61.126.189:1521/IGAPDB.QSDEVPUBSUBNET.DEVDNS.ORACLEVCN.COM"
}

variable "oig_db_sys_user" {
  type    = string
  default = "sys"
}

variable "oig_db_sys_user_password" {
  type    = string
  default = "Welcome1"
}

variable "oig_rcu_schema_prefix" {
  type    = string
  default = "OCI"
}

variable "oig_rcu_schema_password" {
  type    = string
  default = "Welcome1"
}

variable "oig_weblogic_domain_user" {
  type    = string
  default = "weblogic"
}

variable "oig_weblogic_domain_user_password" {
  type    = string
  default = "Welcome1"
}

variable "oig_domain_storage_path" {
  type    = string
  default = "/oig"
}

variable "image_docker_registry_url" {
  type    = string
  default = "phx.ocir.io/susengdev/qafd/olcne_idm/idmrepo/oracle/oig:12.2.1.4.0-8-ol7-210525.2125"
}

variable "idmcli_command" {
  type    = string
  default = "install oig k8s --config config/idmcli.yaml"
}

variable "wls_operator_object_storage_url" {
  type    = string
  default = "https://objectstorage.us-ashburn-1.oraclecloud.com/n/idkgvfvqincr/b/bucket-orm-Jan2021/o/operator.zip"
}

variable "operator_image" {
  type = string
  default = "ghcr.io/oracle/weblogic-kubernetes-operator:3.4.2"
}

variable "mp_listing_id" {
  type    = string
  default = "ocid1.appcataloglisting.oc1..aaaaaaaaojnwqgk2lccn24ckldx6ux4qf3rixmjsjwlqhrgynsypk3u4ahma"
}

variable "mp_listing_resource_version" {
  type    = string
  default = "12.2.1.3.190716-090920191549"
}

variable "mp_listing_resource_id" {
  type    = string
  default = "ocid1.image.oc1..aaaaaaaam4f6myslzsdpxzualz6logxiwmg2x3cixm23nrbnhaqsrgo43u7a"
}

variable "ingressHostName" {
  type    = string
  default = "NOVALUE"
}

variable "ssh_private_key" {
  description = "Text of ssh private key.This is an optional parameter. This is needed if one doesn't want to use the auto-generated key."
  type        = string
  sensitive = true
  default = <<EOF
###
###
EOF
}

variable "ssh_public_key" {
   default     = ""
   sensitive = true
}

variable "generate_public_ssh_key" {
  default = true
}
