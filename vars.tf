variable "ssh_bastion_host" {
  type    = string
  default = ""
}

variable "ssh_bastion_user" {
  type    = string
  default = ""
}

variable "ssh_bastion_private_key" {
  type        = string
  default     = ""
  description = "Base64 encoded"
}
