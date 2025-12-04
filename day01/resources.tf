data "digitalocean_ssh_key" "mykey1" {
  name = "mykey1"
}

resource "digitalocean_droplet" "yyx-droplet" {
  name   = "yyx-droplet"
  image  = var.DO_IMAGE
  size   = var.DO_SIZE
  region = var.DO_REGION
  ssh_keys = [ data.digitalocean_ssh_key.mykey1.fingerprint ]

   connection {
     type = "ssh"
     user = "root"
     private_key = file("../id_ecdsa")
     host = self.ipv4_address
   }

   # Install Nginx
   provisioner "remote-exec" {
      inline = [
         "apt update",
         "apt install nginx unzip -y",
         "systemctl daemon-reload",
         "systemctl enable nginx",
         "systemctl start nginx"
      ]
   }

   # Upload assets.zip
   provisioner "file" {
      source = "./assets.zip"
      destination = "/tmp/assets.zip"
   }

   # Extract assets and update index.html
   provisioner "remote-exec" {
      inline = [
         "unzip -o /tmp/assets.zip -d /var/www/html",
         "sed -i 's/Droplet IP address here/${self.ipv4_address}/g' /var/www/html/index.html",
         "systemctl restart nginx"
      ]
   }
}

output "mykey_fingerprint" {
  description = "token ssh key fingerprint"
  value       = data.digitalocean_ssh_key.mykey1.fingerprint
}

output "yyx-droplet_ipv4" {
  value = digitalocean_droplet.yyx-droplet.ipv4_address
}

output "nginx_url" {
  value = "http://${digitalocean_droplet.yyx-droplet.ipv4_address}"
  description = "URL to access your Nginx web server"
}