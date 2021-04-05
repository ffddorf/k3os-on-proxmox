terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.8"
    }
  }

  experiments = [module_variable_optional_attrs]
}

variable "name" {
  type = string
}

variable "pool" {
  type    = string
  default = "Testing"
}

variable "target_node" {
  type    = string
  default = "pm2"
}

variable "storage_pool" {
  type    = string
  default = "system"
}

resource "proxmox_vm_qemu" "k3s_node" {
  name        = var.name
  target_node = var.target_node
  pool        = var.pool
  desc        = "k3s node - managed by Terraform"

  clone      = "k3os-v0.20.4-k3s1r0-patched"
  full_clone = false

  cores   = 2
  sockets = 1
  memory  = 2048

  disk {
    type    = "virtio"
    storage = var.storage_pool
    size    = "4G"
  }

  boot     = "c"
  bootdisk = "virtio0"

  vga {
    type = "serial0"
  }

  serial {
    id   = 0
    type = "socket"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  cloudinit_cdrom_storage = var.storage_pool

  agent     = 1
  os_type   = "cloud-init"
  ipconfig0 = "ip=dhcp,ip6=auto"

  // k3os config
  cicustom = "user=local:snippets/user_data_${var.name}.yml"

  define_connection_info = false
}
