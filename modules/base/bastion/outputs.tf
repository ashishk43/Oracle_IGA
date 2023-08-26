# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

output "bastion_public_ip" {
  value = join(",", data.oci_core_vnic.bastion_vnic.*.public_ip_address)
}


output "bastion_public_key" {
  value = var.generate_public_ssh_key == true ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
  sensitive = true
}

output "bastion_private_key" {
  value = var.generate_public_ssh_key == true ? tls_private_key.public_private_key_pair.private_key_pem : var.ssh_private_key
  sensitive = true
}

output "bastion_instance_principal_group_name" {
  value = "asdasd"
}
