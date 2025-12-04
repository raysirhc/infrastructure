variable DO_TOKEN {
   type = string 
   sensitive = true
}

variable DO_REGION {
   type = string
   default = "sgp1"
}

variable "DO_SIZE" {
   type = string 
   default = "s-2vcpu-4gb"
}

variable DO_IMAGE {
   type = string
   default = "ubuntu-24-04-x64"
}

# Add these variables for Ansible
variable "ansible_user" {
  description = "SSH user for Ansible"
  type        = string
  default     = "root"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for Ansible"
  type        = string
}

variable "code_server_password" {
  description = "Password for code-server"
  type        = string
  sensitive   = true
}