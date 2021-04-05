terraform {
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
  depends_on = [module.user_data]

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

  scsihw   = "virtio-scsi-pci"
  boot     = "c"
  bootdisk = "virtio0"

  vga {
    type   = "serial0"
    memory = 0
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
  cicustom = "user=${module.user_data.location}"

  define_connection_info = false

  force_recreate_on_change_of = sha1(local.user_data_yaml)

  lifecycle {
    ignore_changes = [
      full_clone,
      define_connection_info
    ]
  }
}

output "net_macaddress" {
  value = proxmox_vm_qemu.k3s_node.network[0].macaddr
}
