resource "random_password" "k8s_admin_token" {
  length  = 48
  special = false
}

locals {
  # https://kubernetes.io/docs/reference/access-authn-authz/authentication/#static-token-file
  k8s_token_file = <<EOF
    ${random_password.k8s_admin_token.result},terraform_admin,1000,system:masters
  EOF
}

output "k8s_admin_token" {
  value     = random_password.k8s_admin_token
  sensitive = true
}
