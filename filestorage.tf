resource "oci_file_storage_file_system" "oke_node_pool_storage" {
  availability_domain = element(data.template_file.ad_names.*.rendered,1)
  compartment_id      = var.compartment_ocid
  display_name = "idmFileStorage"
  freeform_tags = {
    "Department" = "oke"
  }
}

resource "oci_file_storage_mount_target" "oke_nodepool_mount_target" {
  availability_domain = element(data.template_file.ad_names.*.rendered,1)
  compartment_id      = var.compartment_ocid
  subnet_id           = oci_core_subnet.lb_regional_subnet.id
  display_name = "oke_nodepool_mount_target"
  freeform_tags = {
    "Department" = "oke"
  }
}

resource "oci_file_storage_export_set" "oke_export_set" {
  mount_target_id = oci_file_storage_mount_target.oke_nodepool_mount_target.id
  display_name      = "oke_export_set"
  max_fs_stat_bytes = "23843202333"
  max_fs_stat_files = "223442"
}

resource "oci_file_storage_export" "oke_export" {
  export_set_id  = oci_file_storage_export_set.oke_export_set.id
  file_system_id = oci_file_storage_file_system.oke_node_pool_storage.id
  path           = var.oig_domain_storage_path
  export_options {
    source                         = "10.180.8.0/21"
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = false
  }
}

data "oci_core_private_ips" ip_mount_target {
  subnet_id = oci_file_storage_mount_target.oke_nodepool_mount_target.subnet_id
  filter {
    name   = "id"
    values = [oci_file_storage_mount_target.oke_nodepool_mount_target.private_ip_ids.0]
  }
}

resource "null_resource" "mount_fss_on_instance" {
  depends_on = [oci_file_storage_file_system.oke_node_pool_storage,
                oci_file_storage_export.oke_export, 
                oci_core_instance.sample_bastion
                ]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = oci_core_instance.sample_bastion.public_ip
      user        = "opc"
      private_key = module.base.bastion_private_key

    bastion_host        = oci_core_instance.sample_bastion.public_ip
    bastion_user        = "opc"
    bastion_private_key = module.base.bastion_private_key
    }
    inline = [
      "sudo yum -y install nfs-utils > nfs-utils-install.log",
      "sudo mkdir -p /mnt/${var.oig_domain_storage_path}",
      "sudo mount ${local.mount_target_ip_address}:/${var.oig_domain_storage_path} /mnt/${var.oig_domain_storage_path}",
      "sudo chmod -R 777 /mnt/${var.oig_domain_storage_path} || true",
    ]
  }
}

resource "oci_core_instance" "sample_bastion" {
  availability_domain = element(data.template_file.ad_names.*.rendered,1)
  compartment_id      = var.compartment_ocid
  create_vnic_details {
    subnet_id           = oci_core_subnet.lb_regional_subnet.id
    display_name   = "sample-bastion-vnic"
  }
  display_name = "mountnode"
  extended_metadata = {
    ssh_authorized_keys = module.base.bastion_public_key
    subnet_id           = oci_core_subnet.lb_regional_subnet.id
  }
  shape = var.bastion_shape
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.bastion_images.images.0.id
  }
  timeouts {
    create = "60m"
  }
}

data "oci_core_images" "bastion_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  filter {
    name   = "operating_system_version"
    values = ["7\\.[7-9]"]
    regex  = true
  }
#  operating_system_version = "7.8"
  shape                    = var.bastion_shape
  sort_by                  = "TIMECREATED"
}