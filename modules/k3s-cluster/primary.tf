module "k3s_primary" {
  source = "../k3s-node"

  name        = "${var.cluster_name}-primary-1"
  target_node = "pve1"

  k3s_manager_node = true
  k3s_server_url   = ""
  k3s_token        = local.node_token
}
