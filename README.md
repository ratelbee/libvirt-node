# Libvirt Node Example
```
module "node" {
  #=====================================
  #=========BASE CONFIGURATION==========
  #=====================================
  source        = "$SOURCE_GIT_LINK"
  vm_count      = 2
  index_start = 1
  os_img_url       = "http://localhost/ubuntu-20.04-server-cloudimg-amd64.img"
  #=====================================
  #=======HARDWARE CONFIGURATION========
  #=====================================
  memory        = "512"
  hugepages     = false
  vcpu          = 1
  pool          = "vmssd"
  #=====================================
  #=======NETWORK  CONFIGURATION========
  #=====================================
  bridge          = "br0"
  dhcp 		      = false
  ip_address 	  = [
                   "172.16.1.191",
                   "172.16.1.192",
                  ]
  ip_gateway       = "172.16.1.1"
  ip_resolve       = "'172.16.1.30', '8.8.8.8'"
  ip_netmask       = "24"
  #ip_domain       = "example.com"
  #=====================================
  #=========HOST CONFIGURATION==========
  #=====================================
  fqdn              = "example.com"
  time_zone         = "Europe/Moscow"
  district          = "local"
  hostname          = "name"
  #custom_template  = "./custom.tpl" #external template
  #module_template  = "docker"
  #=====================================
  #========FILES AND EXECUTIONS=========
  #=====================================
  init_file_source_path   = ""
  init_file_target_path   = ""
  init_exec               = ""
  #apply_file_source_path =
  #apply_file_target_path =
  #apply_exec             = "echo  $(date) 'Terraform test exec from job'"
  #=====================================
  #=========USER CONFIGURATION==========
  #=====================================
  admin            = "admin"
  passwd           = "admin"
  ssh_keys         = file("./id_rsa.pub") # key for guest machines
  ssh_private_key  = file("./id_rsa") # kye for exec in guest machines
}

output "node" {
  value = module.node
}

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.11"
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
