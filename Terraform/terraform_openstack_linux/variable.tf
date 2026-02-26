
variable "image_name" {
  type    = string
}

variable "flavor_name" {
  type    = string
  default = "Large"
}

variable "server_name" {
  type    = string
}

variable "boot_disk_size" {
  type    = number
}

variable "boot_disk_type" {
  type    = string
  default = "__DEFAULT__"
}

variable "network_names" {
  description = "List of network names to attach to the instance"
  type        = list(string)
  default     = ["general-network"]
}


variable "availability_zone" {
  type    = string
  default = "nova"
}

variable "additional_volumes" {
  type = list(object({
    name        = string
    size        = number
  }))
  default = []
}

variable "ansible_playbook" {
  description = "Path to the Ansible playbook to run"
  type        = string
}

variable "os_user" {
  description = "os user for Ansible"
  type        = string
  default     = "tcsadmin"
}

variable "os_password" {
  description = "os password for Ansible"
  type        = string
  default     = "VMware1!"
}

variable "user_data_file" {
  description = "Path to the cloud-init user-data file"
  type        = string
}

variable "user_name" {
  description = "Username to Login into the Openstack"
  type        = string
}

variable "tenant_name" {
  description = "Tenant Name in openstack"
  type        = string
}

variable "password" {
  description = "Openstack user password"
  type        = string
}

variable "auth_url" {
  description = "Openstack auth keystone url"
  type        = string
}

variable "region" {
  description = "Openstack Region"
  type        = string
}
