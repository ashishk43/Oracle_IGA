# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "oci_base_identity" {
  type = object({
    compartment_id       = string
    compartment_name     = string
    tenancy_id           = string
  })
}

variable "oci_bastion_general" {
  type = object({
    label_prefix = string
    home_region  = string
    region       = string
  })
}

variable "oci_bastion" {
  type = object({
    bastion_shape                  = string
    create_bastion                 = bool
    bastion_access                 = string
    enable_instance_principal      = bool
    image_id                       = string
    package_upgrade                = bool
  })
}

variable "oci_bastion_infra" {
  type = object({
    ig_route_id          = string
    vcn_cidr             = string
    vcn_id               = string
    ad_names             = list(string)
    newbits              = number
    subnets              = number
    availability_domains = string
  })
}

variable "oci_marketplace_subscription" {
  type = object({
    mp_listing_id               = string
    mp_listing_resource_id      = string
    mp_listing_resource_version = string
  })
}

# ssh
variable "ssh_private_key" {}

variable "ssh_public_key" {}
variable "generate_public_ssh_key" {}
