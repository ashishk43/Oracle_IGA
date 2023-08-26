# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "local_file" "test_cluster_kube_config_file" {
  content  = data.oci_containerengine_cluster_kube_config.test_cluster_kube_config.content
  depends_on = [null_resource.create_local_kubeconfig, oci_containerengine_cluster.test_cluster]
  filename = "${path.root}/generated/kubeconfig"
}

resource "null_resource" "create_local_kubeconfig" {
  provisioner "local-exec" {
    command = "rm -rf generated"
  }
  provisioner "local-exec" {
    command = "mkdir generated"
  }
  provisioner "local-exec" {
    command = "touch generated/kubeconfig"
  }
}

data "template_file" "install_kubectl" {
  template = file("${path.root}/scripts/install_kubectl.template.sh")
}

resource "null_resource" "install_kubectl_bastion" {
  connection {
    agent       = false
    host        = module.base.bastion_public_ip
    private_key = module.base.bastion_private_key
    timeout     = "40m"
    user        = "opc"
  }
  depends_on = [local_file.test_cluster_kube_config_file]
  provisioner "file" {
    content     = data.template_file.install_kubectl.rendered
    destination = "~/install_kubectl.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_kubectl.sh",
      "bash $HOME/install_kubectl.sh",
      "sleep 500",
      "rm -f $HOME/install_kubectl.sh"
    ]
  }
}

resource "null_resource" "write_kubeconfig_bastion" {
  connection {
    agent       = false
    host        = module.base.bastion_public_ip
    private_key = module.base.bastion_private_key
    timeout     = "40m"
    user        = "opc"
  }
  depends_on = [local_file.test_cluster_kube_config_file, null_resource.install_kubectl_bastion]
  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/.kube",
    ]
  }
  provisioner "file" {
    source      = "generated/kubeconfig"
    destination = "~/.kube/config"
  }
}