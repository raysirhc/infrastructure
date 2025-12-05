data "digitalocean_ssh_key" "mykey1" {
  name = "mykey1"
}

resource "digitalocean_droplet" "yyx-tf-ansible" {
  name   = "yyx-tf-ansible"
  image  = "ubuntu-24-04-x64"
  size   = "s-1vcpu-1gb"
  region = "sgp1"
  tags = [ "ubuntu", "nginx" ]
}

output mynginx_ip {
   value = digitalocean_droplet.yyx-tf-ansible.ipv4_address
}