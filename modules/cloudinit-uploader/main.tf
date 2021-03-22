terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "0.2.2"
    }
  }
}

variable "target_node" {
  type = string
}

variable "pm_pool" {
  type        = string
  description = "Proxmox Pool to use for the uploader container"
  default     = ""
}

variable "public_prefix" {
  type = string
}

resource "tls_private_key" "uploader" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "macaddress" "uploader" {}

resource "proxmox_lxc" "uploader" {
  target_node  = var.target_node
  hostname     = "cloudinit-uploader"
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  unprivileged = false
  ostype       = "ubuntu"
  onboot       = true
  start        = true
  //pool         = var.pm_pool

  ssh_public_keys = tls_private_key.uploader.public_key_openssh

  rootfs {
    storage = "local"
    size    = "1G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    ip6    = "auto"
    hwaddr = macaddress.uploader.address
  }
}

module "remote_address" {
  source = "../ip6-compute"

  mac    = macaddress.uploader.address
  prefix = var.public_prefix
}

output "ssh_user" {
  value = "root"
}

output "ssh_host" {
  value = module.remote_address.address
}

output "ssh_private_key" {
  value     = tls_private_key.uploader.private_key_pem
  sensitive = true
}
