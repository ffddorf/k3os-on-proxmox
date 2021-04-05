module "cluster" {
  source = "./modules/k3s-cluster"

  cluster_name = "dorfadventure"
}
