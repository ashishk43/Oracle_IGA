# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {

  oci_base_identity = {
    compartment_name     = var.compartment_name
    compartment_id       = var.compartment_ocid
    tenancy_id           = var.tenancy_ocid
  }

  oci_base_general = {
    disable_auto_retries = true
    label_prefix         = "oke"
    region               = var.region
  }

  oci_base_vcn = {
    vcn_cidr               = var.vcn_cidr
    vcn_dns_label          = var.vcn_dns_label
    vcn_name               = "oke vcn"
    create_nat_gateway     = true
    nat_gateway_name       = "nat"
    create_service_gateway = true
    service_gateway_name   = "sg"
  }

  oci_base_bastion = {
    newbits                        = var.newbits
    subnets                        = var.subnets
    bastion_shape                  = var.bastion_shape
    create_bastion                 = true
    bastion_access                 = "ANYWHERE"
    enable_instance_principal      = true
    image_id                       = "NONE"
    availability_domains           = var.availability_domains
    ssh_private_key                = var.ssh_private_key
    ssh_public_key                 = var.ssh_public_key
    package_upgrade                = true
  }

helm = {
    add_incubator_repo = false
    add_jetstack_repo  = false
    helm_version       = var.helm_version
    install_helm       = true
  }

  oke_bastion = {
    bastion_public_ip         = module.base.bastion_public_ip
    create_bastion            = true
    enable_instance_principal = true
  }

  oci_base_marketplace = {
    mp_listing_id               = var.mp_listing_id
    mp_listing_resource_id      = var.mp_listing_resource_id
    mp_listing_resource_version = var.mp_listing_resource_version
  }
}
