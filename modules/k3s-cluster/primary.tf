locals {
  computed_api_domain = length(var.api_domain) > 0 ? var.api_domain : "${var.cluster_name}.k3s.freifunk-duesseldorf.de"
}

variable "control_plane_port" {
  type    = number
  default = 6443
}

variable "ip6_prefix" {
  type        = string
  description = "Public IPv6 prefix assigned via RA at the hosting location"
}

module "k3s_primary" {
  source = "../k3s-node"

  name        = "${var.cluster_name}-primary-1"
  target_node = "pve1"

  control_plane  = true
  k3s_server_url = "" # primary can omit this
  k3s_token      = local.node_token
  k3s_args = [
    "--https-listen-port=${var.control_plane_port}", # for proxying via cloudflare
    "--tls-san=${local.computed_api_domain}",
    "--disable=servicelb",
    "--disable=traefik",
    "--kube-apiserver-arg=token-auth-file=${local.k8s_token_file.path}",
  ]

  k3os_write_files = [
    local.k8s_token_file
  ]

  ip6_prefix = var.ip6_prefix

  providers = {
    aws.cloud_init = aws.cloud_init
  }
}

locals {
  control_plane_url = "https://[${module.k3s_primary.primary_ip6}]:${var.control_plane_port}"
}

output "control_plane_ip6" {
  value = module.k3s_primary.primary_ip6
}
