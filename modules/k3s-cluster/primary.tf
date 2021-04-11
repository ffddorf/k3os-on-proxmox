locals {
  computed_api_domain = length(var.api_domain) > 0 ? var.api_domain : "${var.cluster_name}.k3s.freifunk-duesseldorf.de"
}

module "k3s_primary" {
  source = "../k3s-node"

  name        = "${var.cluster_name}-primary-1"
  target_node = "pve1"

  control_plane  = true
  k3s_server_url = "" # primary can omit this
  k3s_token      = local.node_token
  k3s_args = [
    "--tls-san=${local.computed_api_domain}",
    "--disable=servicelb",
    "--disable=traefik",
    "--kube-apiserver-arg=token-auth-file=${local.k8s_token_file.path}",
  ]

  k3os_write_files = [
    local.k8s_token_file
  ]

  providers = {
    aws.cloud_init = aws.cloud_init
  }
}

variable "ip6_prefix" {
  type        = string
  description = "Public IPv6 prefix assigned via RA at the hosting location"
}

module "primary_ip6" {
  source = "../eui64-compute"

  mac    = module.k3s_primary.net_macaddress
  prefix = var.ip6_prefix
}

output "control_plane_ip6" {
  value = module.primary_ip6.address
}
