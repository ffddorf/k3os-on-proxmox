terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.8"
    }
  }
}

resource "random_uuid" "vm_unique_id" {}

locals {
  vm_uuid = random_uuid.vm_unique_id.result
}
