# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl
variable "oci_base_identity" {
  type = object({
    compartment_id       = string
    compartment_name     = string
    tenancy_id           = string
  })
}

variable "oci_base_general" {
  type = object({
    disable_auto_retries = bool
    label_prefix         = string
    region               = string
  })
}

variable "oci_base_vcn" {
  type = object({
    vcn_cidr               = string
    vcn_dns_label          = string
    vcn_name               = string
    create_nat_gateway     = bool
    nat_gateway_name       = string
    create_service_gateway = bool
    service_gateway_name   = string
  })
}

variable "oci_base_bastion" {
  type = object({
    newbits                        = number
    subnets                        = number
    bastion_shape                  = string
    create_bastion                 = bool
    bastion_access                 = string
    enable_instance_principal      = bool
    image_id                       = string
    availability_domains           = string
    package_upgrade                = bool
  })
}

variable "oci_base_marketplace" {
  type = object({
    mp_listing_id               = string
    mp_listing_resource_id      = string
    mp_listing_resource_version = string
  })
}

variable "ssh_private_key" {
  description = "path to ssh private key"
}

variable "ssh_public_key" {
  description = "path to ssh public key"
}

variable "generate_public_ssh_key" {}