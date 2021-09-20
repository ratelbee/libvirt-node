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
  description = "From where the indexig start"
  default = 1
}

variable "district" {
  description = "VM hostname prefix"
  default     = "vm"
}

variable "srv_tpl" {
  description = "Choosing a template for a service"
  type        = string
  default     = "default"
}


variable "hostname" {
  description = "VM hostname"
  type        = string
  default     = "default"
}

locals {
  full_name = "${var.district}-${var.hostname != "default" ? var.hostname : var.srv_tpl}"
}

variable "fqdn" {
  description = "VM or FQDN"
  type        = string
  default     = "alyans.alyans-auto.ru"
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

variable "system_volume" {
  description = "System Volume size (GB)"
  default = 10
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

variable "ip_resolv" {
  description = "IP addresses of a nameservers"
  default     =  "192.168.123.1" 
}

variable "ip_gateway" {
  description = "IP addresses of a gateway"
  default     = "192.168.123.1"
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
  default     = "~/.ssh/id_ed25519"
}
