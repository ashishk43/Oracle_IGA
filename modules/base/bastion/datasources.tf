# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "bastion_template" {
  template = file("${path.module}/scripts/bastion.template.sh")
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "template_file" "bastion_cloud_init_file" {
  template = file("${path.module}/cloudinit/bastion.template.yaml")
  vars = {
    bastion_sh_content = base64gzip(data.template_file.bastion_template[0].rendered)
    package_upgrade    = var.oci_bastion.package_upgrade
  }
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "template_cloudinit_config" "bastion" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "bastion.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.bastion_cloud_init_file[0].rendered
  }
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "template_file" "tesseract_template" {
  template = file("${path.module}/scripts/tesseract.template.sh")
  vars = {
    bastion_ip       = join(",", data.oci_core_vnic.bastion_vnic.*.public_ip_address)
    private_key = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.private_key_pem : var.ssh_private_key
  }
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "oci_core_vnic_attachments" "bastion_vnics_attachments" {
  availability_domain = var.oci_bastion_infra.availability_domains
  compartment_id      = var.oci_base_identity.compartment_id
  instance_id         = oci_core_instance.bastion[0].id
  count               = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "oci_core_vnic" "bastion_vnic" {
  vnic_id = lookup(data.oci_core_vnic_attachments.bastion_vnics_attachments[0].vnic_attachments[0], "vnic_id")
  count   = var.oci_bastion.create_bastion == true ? 1 : 0
}

data "oci_core_instance" "bastion" {
  instance_id = oci_core_instance.bastion[0].id
  count       = var.oci_bastion.create_bastion == true ? 1 : 0
}
