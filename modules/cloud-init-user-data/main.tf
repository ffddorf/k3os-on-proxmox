variable "object_store_bucket" {
  type    = string
  default = "cloud-init"
}

variable "content" {
  type = string
}

variable "id" {
  type = string
}

locals {
  user_data_key = "user_data_${var.id}"
}

resource "aws_s3_bucket_object" "user_data" {
  bucket  = var.object_store_bucket
  key     = local.user_data_key
  content = var.content
}

output "location" {
  value = "cloud-init:snippets/${local.user_data_key}"
}
