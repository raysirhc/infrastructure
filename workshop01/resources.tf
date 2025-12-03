data "digitalocean_ssh_key" "mykey" {
  name = "mykey"
}

resource "digitalocean_droplet" "yyx-droplet" {
  name   = "yyx-droplet"
  image  = var.DO_IMAGE
  size   = var.DO_SIZE
  region = var.DO_REGION
}

output "mykey_fingerprint" {
  description = "token ssh key fingerprint"
  value       = data.digitalocean_ssh_key.mykey.fingerprint
}

output "yyx-droplet_ipv4" {
  value = digitalocean_droplet.yyx-droplet.ipv4_address
}

resource "docker_image" "nginx_image" {
  name = "nginx:1.29"
}

# #resource "docker_container" "nginx" {
# #count = 5
# #name  = "mynginx-${count.index}"
# // # image = docker_image.nginx_image.image_id

# // ports {
#     internal = 80
#     external = 8080 + count.index
# }
# }

resource "docker_container" "nginx" {
count = 5
name  = "mynginx-${count.index}"
image = docker_image.nginx_image.image_id

ports {
    internal = var.nginx_image.internal_port
    external = var.nginx_image.external_port
}
}