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

  pve_object_store_access_key = var.pve_object_store_access_key
  pve_object_store_secret_key = var.pve_object_store_secret_key
}
