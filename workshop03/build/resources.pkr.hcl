variable "DO_TOKEN" {
  type      = string
  sensitive = true
}

source "digitalocean" "yyx-packer" {
  api_token    = var.DO_TOKEN
  image        = "ubuntu-24-04-x64"
  region       = "sgp1"
  size         = "s-2vcpu-4gb"
  ssh_username = "root"
  snapshot_name = "packer-with-nginx-and-codeserver"
}

build {
  sources = ["source.digitalocean.yyx-packer"]

  provisioner ansible {
    playbook_file = "playbook.yaml"
  }
}
