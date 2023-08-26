// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_containerengine_node_pool" "test_node_pool" {
  cluster_id         = oci_containerengine_cluster.test_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = data.oci_containerengine_node_pool_option.test_node_pool_option.kubernetes_versions[length(data.oci_containerengine_node_pool_option.test_node_pool_option.kubernetes_versions)-1]
  name               = var.node_pool_name
 # node_image_name    = var.node_pool_node_image_name
  node_shape         = var.node_pool_node_shape
  depends_on         = [oci_containerengine_cluster.test_cluster]
  initial_node_labels {
    key   = var.node_pool_initial_node_labels_key
    value = var.node_pool_initial_node_labels_value
  }

  node_source_details {
    #Required
    image_id    = local.oracle_linux_images.0
    source_type = "IMAGE"
   }

  node_config_details {
    dynamic "placement_configs" {
      iterator = ad_iterator
      for_each = data.template_file.ad_names.*.rendered
      content {
        availability_domain = ad_iterator.value
        subnet_id           = oci_core_subnet.nodepool_regional_subnet.id
      }
    }
    size = var.number_of_nodes
  }
  ssh_public_key      = module.base.bastion_public_key

  lifecycle {
    ignore_changes = [kubernetes_version, node_source_details[0].image_id] 
  }

}

locals {
  all_sources = data.oci_containerengine_node_pool_option.test_node_pool_option.sources

  oracle_linux_images = [for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-7.9-20[0-9]*.[0-9]*.[0-9]*-[0-9]*$",source.source_name)) > 0]
}

