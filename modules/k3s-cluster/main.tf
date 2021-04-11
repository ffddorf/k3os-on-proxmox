variable "cluster_name" {
  type = string
}

variable "api_domain" {
  type        = string
  description = "used for the API TLS cert"
  default     = "" # defaults to <cluster_name>.k3s.freifunk-duesseldorf.de
}

provider "aws" {
  alias = "cloud_init"
}
