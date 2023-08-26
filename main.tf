module "base" {
  source                  = "./modules/base"
  oci_base_identity       = local.oci_base_identity
  oci_base_general        = local.oci_base_general
  oci_base_vcn            = local.oci_base_vcn
  oci_base_bastion        = local.oci_base_bastion
  oci_base_marketplace    = local.oci_base_marketplace
  ssh_private_key         = var.ssh_private_key
  ssh_public_key          = var.ssh_public_key
  generate_public_ssh_key = var.generate_public_ssh_key

}

module "oke" {
  source        = "./modules/oke"
  oke_bastion   = local.oke_bastion
  helm          = local.helm
}

