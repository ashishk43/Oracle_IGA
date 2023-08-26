variable "helm" {
  type = object({
    add_incubator_repo = bool
    add_jetstack_repo  = bool
    helm_version       = string
    install_helm       = bool
  })
}

variable "cluster_kube_config_expiration" {
  default = 2592000
}
variable "cluster_kube_config_token_version" {
  default = "1.0.0"
}

variable "oke_bastion" {
  type = object({
    bastion_public_ip         = string
    create_bastion            = bool
    enable_instance_principal = bool
  })
}
