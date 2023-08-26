# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl
data "oci_core_images" "bastion_images" {
  compartment_id           = var.oci_base_identity.compartment_id
  operating_system         = "Oracle Linux"
  shape                    = var.oci_bastion.bastion_shape
  sort_by                  = "TIMECREATED"
  filter {
    name   = "operating_system_version"
    values = ["7\\.[7-9]"]
    regex  = true
  }
}

resource "oci_core_instance" "bastion" {
  availability_domain = var.oci_bastion_infra.availability_domains
  compartment_id      = var.oci_base_identity.compartment_id
  create_vnic_details {
    subnet_id      = oci_core_subnet.bastion[0].id
    display_name   = "${var.oci_bastion_general.label_prefix}-bastion-vnic"
    hostname_label = "bastion"
  }
  display_name = "${var.oci_bastion_general.label_prefix}-bastion"
  extended_metadata = {
    #ssh_authorized_keys = var.ssh_public_key
    ssh_authorized_keys = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
    user_data           = data.template_cloudinit_config.bastion[0].rendered
    subnet_id           = oci_core_subnet.bastion[0].id
  }
  
  shape = var.oci_bastion.bastion_shape
  source_details {
    source_type = "image"
    source_id   = var.oci_bastion.image_id == "NONE" ? data.oci_core_images.bastion_images.images.0.id : var.oci_bastion.image_id
  }
  timeouts {
    create = "60m"
  }
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm   = "RSA"
}

resource "local_file" "tesseract" {
  content  = data.template_file.tesseract_template[0].rendered
  filename = "${path.root}/scripts/tesseract.sh"
  count    = var.oci_bastion.create_bastion == true ? 1 : 0
}

resource "oci_core_instance" "monitoringnode" {
  availability_domain = var.oci_bastion_infra.availability_domains
  compartment_id      = var.oci_base_identity.compartment_id
  create_vnic_details {
    subnet_id      = oci_core_subnet.bastion[0].id
    display_name   = "monitoring-bastion-vnic"
    hostname_label = "monitoringnode"
  }
  display_name = "monitoringnode"
  extended_metadata = {
    ssh_authorized_keys = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
    user_data           = data.template_cloudinit_config.bastion[0].rendered
    subnet_id           = oci_core_subnet.bastion[0].id
  }
  shape = var.oci_bastion.bastion_shape
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1..aaaaaaaam4f6myslzsdpxzualz6logxiwmg2x3cixm23nrbnhaqsrgo43u7a"
  }
  timeouts {
    create = "60m"
  }
  count = var.oci_bastion.create_bastion == true ? 1 : 0
}

resource "oci_core_app_catalog_listing_resource_version_agreement" "mp_image_agreement" {
  count = 1
  listing_id               = var.oci_marketplace_subscription.mp_listing_id
  listing_resource_version = var.oci_marketplace_subscription.mp_listing_resource_version
}

resource "oci_core_app_catalog_subscription" "mp_image_subscription" {
  count                    = 1
  compartment_id           = var.oci_base_identity.compartment_id
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.mp_image_agreement[count.index].time_retrieved
  timeouts {
    create = "20m"
  }
}

data "oci_core_app_catalog_subscriptions" "mp_image_subscription" {
  count = 1
  compartment_id = var.oci_base_identity.compartment_id
  listing_id = var.oci_marketplace_subscription.mp_listing_id
  filter {
    name   = "listing_resource_version"
    values = [var.oci_marketplace_subscription.mp_listing_resource_version]
  }
}