resource "random_password" "node_token" {
  length  = 48
  special = false
}

locals {
  node_token = random_password.node_token.result
}
