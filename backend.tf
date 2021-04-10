terraform {
  backend "remote" {
    organization = "ffddorf"

    workspaces {
      name = "k3os-on-proxmox"
    }
  }

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.8"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://pve.freifunk-duesseldorf.de/api2/json"
  # Please make sure `PM_USER` and `PM_PASS` are set in the environment
}
