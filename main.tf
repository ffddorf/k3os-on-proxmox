variable "pve_object_store_access_key" {
  type = string
}

variable "pve_object_store_secret_key" {
  type      = string
  sensitive = true
}

locals {
  cluster_name = "dorfadventure"
}

module "cluster" {
  source = "./modules/k3s-cluster"

  cluster_name       = local.cluster_name
  ip6_prefix         = "2001:678:b7c:201::/64"

  providers = {
    aws.cloud_init = aws.cloud_init
  }
}

# Cloudflare style
output "dns_records" {
  value = [
    {
      name    = "k3s-${local.cluster_name}"
      value   = module.cluster.control_plane_ip6
      type    = "AAAA"
      proxied = true
    }
  ]
}

output "k8s_api_token" {
  value     = module.cluster.k8s_api_token
  sensitive = true
}
