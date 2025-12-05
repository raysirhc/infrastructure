data "digitalocean_ssh_key" "mykey1" {
  name = "mykey1"
}

data "digitalocean_image" "packer_snapshot" {
  name = "packer-with-nginx-and-codeserver"
}

resource "digitalocean_droplet" "yyx-tf-ansible" {
  name   = "yyx-tf-ansible"
  image  = data.digitalocean_image.packer_snapshot.id
  size   = var.DO_SIZE
  region = var.DO_REGION
  ssh_keys = [ data.digitalocean_ssh_key.mykey1.fingerprint ]

   connection {
     type = "ssh"
     user = var.ansible_user
     private_key = file(var.ssh_private_key_path)
     host = self.ipv4_address
   }

}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    droplet_ip             = digitalocean_droplet.yyx-tf-ansible.ipv4_address
    ansible_user           = var.ansible_user
    ssh_key_path           = var.ssh_private_key_path
  })
  filename = "${path.module}/inventory.yaml"
}


output "mykey_fingerprint" {
  description = "token ssh key fingerprint"
  value       = data.digitalocean_ssh_key.mykey1.fingerprint
}

output "droplet_ip" {
  value       = digitalocean_droplet.yyx-tf-ansible.ipv4_address
  description = "IP address of the droplet"
}

output "ansible_connection_info" {
  value = {
    host         = digitalocean_droplet.yyx-tf-ansible.ipv4_address
    user         = var.ansible_user
    ssh_key_path = var.ssh_private_key_path
  }
  description = "Connection information for Ansible"
}