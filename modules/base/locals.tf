# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
  oci_base_vcn = {
    compartment_id         = var.oci_base_identity.compartment_id
    label_prefix           = var.oci_base_general.label_prefix
    create_nat_gateway     = var.oci_base_vcn.create_nat_gateway
    nat_gateway_name       = var.oci_base_vcn.nat_gateway_name
    create_service_gateway = var.oci_base_vcn.create_service_gateway
    service_gateway_name   = var.oci_base_vcn.service_gateway_name
    vcn_cidr               = var.oci_base_vcn.vcn_cidr
    vcn_dns_label          = var.oci_base_vcn.vcn_dns_label
    vcn_name               = var.oci_base_vcn.vcn_name
  }

  oci_bastion_general = {
    label_prefix = var.oci_base_general.label_prefix
    home_region  = lookup(data.oci_identity_regions.home_region.regions[0], "name")
    region       = var.oci_base_general.region
  }

  oci_bastion_infra = {
    ig_route_id          = module.vcn.ig_route_id
    vcn_cidr             = var.oci_base_vcn.vcn_cidr
    vcn_id               = module.vcn.vcn_id
    ad_names             = data.template_file.ad_names.*.rendered
    newbits              = var.oci_base_bastion.newbits
    subnets              = var.oci_base_bastion.subnets
    availability_domains = var.oci_base_bastion.availability_domains
  }

  oci_bastion = {
    bastion_shape                  = var.oci_base_bastion.bastion_shape
    create_bastion                 = var.oci_base_bastion.create_bastion
    bastion_access                 = var.oci_base_bastion.bastion_access
    enable_instance_principal      = var.oci_base_bastion.enable_instance_principal
    image_id                       = var.oci_base_bastion.image_id
    package_upgrade                = var.oci_base_bastion.package_upgrade
  }

  oci_marketplace_subscription = {
    mp_listing_id               = var.oci_base_marketplace.mp_listing_id
    mp_listing_resource_id      = var.oci_base_marketplace.mp_listing_resource_id
    mp_listing_resource_version = var.oci_base_marketplace.mp_listing_resource_version
  }
}
