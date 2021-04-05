locals {
  computed_api_domain = length(var.api_domain) > 0 ? var.api_domain : "${var.cluster_name}.k3s.freifunk-duesseldorf.de"
}

module "k3s_primary" {
  source = "../k3s-node"

  name        = "${var.cluster_name}-primary-1"
  target_node = "pve1"

  k3s_manager_node = true
  k3s_server_url   = "" # primary can omit this
  k3s_token        = local.node_token
  k3s_args = [
    "--tls-san=${local.computed_api_domain}",
    "--disable=servicelb",
    "--disable=traefik",
  ]

  pve_object_store_access_key = var.pve_object_store_access_key
  pve_object_store_secret_key = var.pve_object_store_secret_key
}
