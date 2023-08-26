# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

output "ad_names" {
  value = sort(data.template_file.ad_names.*.rendered)
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_public_key" {
  value = module.bastion.bastion_public_key
  sensitive = true
}

output "bastion_private_key" {
  value = module.bastion.bastion_private_key
  sensitive = true
}

output "group_name" {
  value = module.bastion.bastion_instance_principal_group_name
}

output "ig_route_id" {
  value = module.vcn.ig_route_id
}

output "nat_gateway_id" {
  value = module.vcn.nat_gateway_id
}

output "nat_route_id" {
  value = module.vcn.nat_route_id
}

output "vcn_id" {
  value = module.vcn.vcn_id
}

output "home_region" {
  value = lookup(data.oci_identity_regions.home_region.regions[0], "name")
}

# convenient output
output "ssh_to_bastion" {
  value     = "ssh -i ${module.bastion.bastion_private_key} opc@${module.bastion.bastion_public_ip}"
  sensitive = true
}

