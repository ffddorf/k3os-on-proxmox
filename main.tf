module "cloudinit-uploader" {
  source = "./modules/cloudinit-uploader"

  target_node   = "pm2"
  public_prefix = "2001:678:b7c:201::/64"
  pm_pool       = "Testing"
}

resource "null_resource" "cloud_init_config" {
  connection {
    type        = "ssh"
    host        = module.cloudinit-uploader.ssh_host
    user        = module.cloudinit-uploader.ssh_user
    private_key = module.cloudinit-uploader.ssh_private_key

    bastion_host        = var.ssh_bastion_host
    bastion_user        = var.ssh_bastion_user
    bastion_private_key = base64decode(var.ssh_bastion_private_key)
  }

  provisioner "file" {
    content     = "hello-world 🎡"
    destination = "/mnt/cloudinit/cloudinit-test2.yml"
  }
}
