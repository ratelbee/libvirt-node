# Libvirt Node Example
```
module "node" {
  #path to module
  source        = "$SOURCE_GIT_LINK"
  #count of domain
  vm_count      = 2
  #fqdn for hostname 
  fqdn          = "example.com"
  memory        = "512"
  hugepages     = false
  vcpu          = 1
  pool          = "vmssd"
  bridge        = "br0"
  dhcp 		      = false
  ip_address 	  = [
                   "172.16.1.191",
                   "172.16.1.192",
                  ]
  ip_gateway       = "172.16.1.1"
  ip_resolv        = "'172.16.1.30', '8.8.8.8'"
  ip_netmask       = "24"
  admin            = "admin"
  passwd           = "admin"
  ssh_keys         = file("./id_rsa.pub") # key for guest machines
  time_zone        = "Europe/Moscow"
  os_img_url       = "http://localhost/ubuntu-20.04-server-cloudimg-amd64.img"
  ssh_private_key  = file("./id_rsa") # kye for exec in guest machines
  #prefix for hostname domain
  district      = "local"
  hostname         = "name"
  #custom_template  = "./custom.tpl" #external template
  #srv_tpl         = "glrnr" #internal template
  init_sp_scripts  = ""
  init_dp_scripts  = ""
  init_exec        = ""
  #apply_exec      = "echo  $(date) 'Terraform test exec from job'"
  
}

output "node" {
  value = module.node
}

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.10"
    }
  }
  required_version = ">= 1.0.6"
}

provider "libvirt" {
   uri = "$QEMU_SSH_URI"
}


```
`$SOURCE_GIT_LINK = "git::https://github.com/ratelbee/libvirt-node.git"`

`"$QEMU_SSH_URI" = "qemu+ssh://libvirt@libvirt-host/system?keyfile=libvirt_id_rsa"`
