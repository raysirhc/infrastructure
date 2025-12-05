variable "DO_TOKEN" {
  type      = string
  sensitive = true
}

source "digitalocean" "yyx-packer" {
  api_token    = var.DO_TOKEN
  image        = "ubuntu-24-04-x64"
  region       = "sgp1"
  size         = "s-1vcpu-1gb"
  ssh_username = "root"
  snapshot_name = "terraform-packer"
}

build {
  sources = ["source.digitalocean.yyx-packer"]

  provisioner ansible {
    playbook_file = "playbook.yaml"
  }
}
