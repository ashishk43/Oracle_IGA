# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "install_helm" {
  template = file("${path.module}/scripts/install_helm.template.sh")
  vars = {
    add_incubator_repo = false
    add_jetstack_repo  = false
    helm_version       = var.helm_version
  }
}

data "template_file" "idmcliconfig" {
  template = file("${path.module}/scripts/idmcli.yaml")
  vars = {
    oigDBURL =  var.oig_db_url
    oigDBSysUser = var.oig_db_sys_user
    oigDBSysPassword = var.oig_db_sys_user_password
# ##########################################
# # Chose credentials for OIG Domain and Schema
# ##########################################
    oigDBUser = var.oig_rcu_schema_prefix
    oigDBPassword = var.oig_rcu_schema_password
    oigDomainUser = var.oig_weblogic_domain_user
    oigDomainPassword = var.oig_weblogic_domain_user_password
# ##########################################
# # Storage Mount parameters for Domain Home
# ##########################################
    weblogicDomainStorageType =  "NFS"
    weblogicDomainStorageNFSServer =  local.mount_target_ip_address
    weblogicDomainStoragePath=  var.oig_domain_storage_path
# ##########################################
# # Common Parameters, Can use these Defaults
# ###########################################
    image = var.image_docker_registry_url
    operatorZipURL = var.wls_operator_object_storage_url
    operatorImage = var.operator_image
    dockerRepo = "http://iad.ocir.io/igcdev"
    ingressSvcType = "LoadBalancer"
    ingressMode = "non-SSL"
    ingressProvider = "nginx"
    nginxnamespace =  "nginx"
  }
}

resource null_resource "install_helm_bastion" {
  connection {
    agent       = false
    host        = module.base.bastion_public_ip
    private_key = module.base.bastion_private_key
    timeout     = "40m"
    user        = "opc"
  }
  depends_on = [null_resource.install_kubectl_bastion, null_resource.write_kubeconfig_bastion]
  provisioner "file" {
    content     = data.template_file.install_helm.rendered
    destination = "~/install_helm.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_helm.sh",
      "bash $HOME/install_helm.sh",
      "rm -f $HOME/install_helm.sh"
    ]
  }
}

resource null_resource "install_oci_client" {
  connection {
    agent       = false
    host        = module.base.bastion_public_ip
    private_key = module.base.bastion_private_key
    timeout     = "40m"
    user        = "opc"
  }
  depends_on = [null_resource.install_kubectl_bastion]
  provisioner "remote-exec" {
    inline = [
        "rm -rf /home/opc/lib/oracle-cli",
        "bash -c \"$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)\" -s --accept-all-defaults"
    ]
  }
}

resource null_resource "invoke_idmcli" {
  connection {
    agent       = false
    host        = module.base.bastion_public_ip
    private_key = module.base.bastion_private_key
    timeout     = "40m"
    user        = "opc"
  }
  depends_on = [null_resource.install_helm_bastion,null_resource.mount_fss_on_instance,null_resource.install_oci_client]
  provisioner "file" {
    content     = data.template_file.idmcliconfig.rendered
    destination = "~/idmcli.yaml"
  }

  provisioner "remote-exec" {
  inline = [
	"rm -rf $HOME/idmcli_unix",
  "rm -rf $HOME/Makefile",
  "rm -rf $HOME/operator.zip",
	"rm -rf $HOME/operator",
	"wget ${var.idm_cli_object_storage_url}",
	"wget $(echo ${var.idm_cli_object_storage_url} | sed 's/idmcli_unix/Makefile/g')",
  "chmod 755 Makefile",
  "chmod 755 $HOME/idmcli_unix",
  "export PYTHONWARNINGS='ignore'",
  "mkdir -p config",
  "mkdir -p idmcli/operator",
  "mv idmcli.yaml config/idmcli.yaml",
  "make drop-rcu",
	"make create-rcu",
	"$HOME/idmcli_unix ${var.idmcli_command} 2> /dev/null || exit_code=$? && (sed -i 's/\\\n/\\n/g' $HOME/idmcli.log ; cat $HOME/idmcli.log ; exit $exit_code) ",
    ]
  }
}