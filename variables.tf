locals {
  full_name = "${var.district != "" ? "${var.district}-" : ""}${var.hostname != "default" ? var.hostname : var.module_template}"
  defined_template = "${path.module}/templates/ci_${var.module_template}.tpl"
  init_file_target_path = "${var.init_file_target_path}"
  init_file_source_path = "${path.module}/${var.init_file_source_path}"
  init_exec = "${path.module}/${var.init_file_source_path}/${var.init_exec}"
}

variable "os_img_url" {
  description = "URL to the OS image"
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "autostart" {
  description = "Autostart the domain"
  default = true
}

variable "vm_count" {
  description = "Number of VMs"
  default = 1
}

variable "index_start" {
  description = "From where the indexing start"
  default = 1
}

variable "district" {
  description = "VM hostname prefix"
  default     = ""
}

variable "module_template" {
  description = "Choosing a template for a service"
  type        = string
  default     = "default"
}


variable "hostname" {
  description = "VM hostname"
  type        = string
  default     = "default"
}

variable "fqdn" {
  description = "VM or FQDN"
  type        = string
  default     = "local"
}

variable "memory" {
  description = "RAM in MB"
  type = string
  default = "1024"
}

variable "hugepages" {
  description = "Set Hugepages"
  type = bool
  default = false
}

variable "vcpu" {
  description = "Number of vCPUs"
  default = 1
}

variable "pool" {
  description = "Storage pool name"
  default = "default"
}

variable "storage_size" {
  description = "System Volume size (GB)"
  type = number
  default = 13
}

variable "share_filesystem" {
  type = object({
    source   = string
    target   = string
    readonly = bool
    mode     = string
  })
  default = {
    source   = null
    target   = null
    readonly = false
    mode     = null
    }
}

variable "dhcp" {
  description = "Use DHCP or Static IP settings"
  type        = bool
  default     = false
}

variable "bridge" {
  description = "Bridge interface"
  default     = "virbr0"
}

variable "ip_address" {
  description = "List of IP addresses"
  type        = list(string)
  default     = [ "192.168.123.101" ]
}

variable "ip_resolve" {
  description = "IP addresses of a nameservers"
  default     =  "192.168.123.1" 
}

variable "ip_netmask" {
  description = "IP addresses of a nameservers"
  type        = number
  default     =  "24" 
}

variable "ip_gateway" {
  description = "IP addresses of a gateway"
  default     = "192.168.123.1"
}

variable "ip_domain" {
  description = "Domain search"
  default     = ""
}

variable "admin" {
  description = "Admin user with ssh access"
  default = "ssh-admin"
}

variable "ssh_keys" {
  description = "Public ssh keys"
  type        = string
  default     = ""
}

variable "passwd" {
  description = "Admin user password"
  default     = "password_example_@#$!346321@Q#%@!fsd"
}

variable "time_zone" {
  description = "Time Zone"
  default     = "Europe/Moscow"
}

variable "ssh_private_key" {
  description = "Private key for SSH connection test"
  default     = ""
}

variable "custom_template" {
  description = "Set A custom Template"
  type        = string
  default     = ""
}

variable "init_file_source_path" {
  description = "Source path for Scripts"
  type        = string
  default     = "scripts"
}

variable "init_file_target_path" {
  description = "Set target path for Scripts"
  type        = string
  default     = "/tmp/"
}

variable "init_exec" {
  description = "Set path for remote exec"
  type        = string
  default     = "remote_exec"
}

variable "apply_file_source_path" {
  description = "Source path for Scripts"
  type        = string
  default     = ""
}

variable "apply_file_target_path" {
  description = "Set target path for Scripts"
  type        = string
  default     = ""
}

variable "apply_exec" {
  description = "Set path for remote exec"
  type        = string
  default     = ""
}
