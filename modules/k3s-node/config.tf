variable "ssh_access_github_users" {
  type    = list(string)
  default = ["mraerino", "nomaster"]
}

variable "k3s_manager_node" {
  type        = bool
  description = "Whether this is a server and not just an agent node"
  default     = false
}

variable "k3s_server_url" {
  type        = string
  description = "URL of the primary node - fine to be empty on manager nodes"
}

variable "k3s_token" {
  type        = string
  description = "Token for joining the cluster"
  sensitive   = true
}

variable "k3s_args" {
  type    = list(string)
  default = []

  description = "Additional arguments for the k3s process. See https://github.com/rancher/k3os#k3osk3s_args"
}

variable "k3s_node_labels" {
  type    = map(string)
  default = {}
}

variable "k3os_write_files" {
  type = list(object({
    path        = string
    content     = string
    owner       = optional(string)
    permissions = optional(string)
    encoding    = optional(string)
    append      = optional(string)
  }))
  default = []
}

locals {
  node_type = var.k3s_manager_node ? "server" : "agent"
  user_data = {
    hostname            = var.name
    ssh_authorized_keys = [for user in var.ssh_access_github_users : "github:${user}"]

    write_files = var.k3os_write_files

    k3os = {
      server_url = var.k3s_server_url
      token      = var.k3s_token
      k3s_args   = concat([local.node_type], var.k3s_args)

      labels = var.k3s_node_labels
    }
  }
}

variable "pve_object_store_access_key" {
  type = string
}

variable "pve_object_store_secret_key" {
  type      = string
  sensitive = true
}

module "user_data" {
  source = "../cloud-init-user-data"

  object_store_access_key = var.pve_object_store_access_key
  object_store_secret_key = var.pve_object_store_secret_key

  id      = local.vm_uuid
  content = yamlencode(local.user_data)
}
