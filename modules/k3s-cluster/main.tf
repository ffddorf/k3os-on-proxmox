variable "cluster_name" {
  type = string
}

variable "api_domain" {
  type        = string
  description = "used for the API TLS cert"
  default     = "" # defaults to <cluster_name>.k3s.freifunk-duesseldorf.de
}

variable "pve_object_store_access_key" {
  type = string
}

variable "pve_object_store_secret_key" {
  type      = string
  sensitive = true
}
