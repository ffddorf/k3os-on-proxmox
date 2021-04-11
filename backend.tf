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

provider "aws" {
  alias = "cloud_init"

  access_key                  = var.pve_object_store_access_key
  secret_key                  = var.pve_object_store_secret_key
  region                      = "us-east-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "pve-object-store.freifunk-duesseldorf.de"
  }
}
