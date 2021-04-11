variable "pve_object_store_access_key" {
  type = string
}

variable "pve_object_store_secret_key" {
  type      = string
  sensitive = true
}

module "cluster" {
  source = "./modules/k3s-cluster"

  cluster_name = "dorfadventure"
  ip6_prefix   = "2001:678:b7c:201::/64"

  providers = {
    aws.cloud_init = aws.cloud_init
  }
}

output "k8s_api_url" {
  value = module.cluster.k8s_api_url
}

output "k8s_api_token" {
  value     = module.cluster.k8s_api_token
  sensitive = true
}
