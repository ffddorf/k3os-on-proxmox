terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.35.0"
    }
  }
}

variable "object_store_endpoint" {
  type    = string
  default = "https://pve-object-store.freifunk-duesseldorf.de"
}

variable "object_store_access_key" {
  type = string
}

variable "object_store_secret_key" {
  type      = string
  sensitive = true
}

provider "aws" {
  access_key                  = var.object_store_access_key
  secret_key                  = var.object_store_secret_key
  region                      = "us-east-1"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.object_store_endpoint
  }
}
