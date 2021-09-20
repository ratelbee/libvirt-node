# Libvirt Node Example
```
module "node" {
  source        = "$SOURCE_GIT_LINK"
  vm_count      = 2
  district      = "fm"
  srv_tpl       = "glrnr"
  fqdn          = "alyans.alyans-auto.ru"
  memory        = "1024"
  hugepages     = false
  vcpu          = 1
  pool          = "vmssd"
  system_volume = 8
  bridge        = "br0"
  dhcp 		= false
  ip_address 	= [
                   "10.20.1.183/24",
                   "10.20.1.184/24",
                   "10.20.1.185/24",
                   "10.20.1.186/24",
                  ]
  ip_gateway    = "10.20.1.1"
  ip_resolv     = "'10.20.1.30', '10.20.0.30'"
  admin         = "user"
  passwd        = "password"
  ssh_keys      = file("./id_rsa.pub")
  time_zone     = "Europe/Moscow"
  os_img_url    = "/vmssd/iso/ubuntu-20.04-server-cloudimg-amd64.img"
  #hostname     = "runner"
  #ssh_private_key = "~/.ssh/id_rsa"
  
}

output "ip_addresses" {
  value = module.node
}

terraform {
  backend "pg" {
    conn_str = "$PG_BACKEND_URI"
  }
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.10"
    }
  }
  required_version = ">= 0.14"
}

provider "libvirt" {
   uri = "$QEMU_SSH_URI"
}


```
`$SOURCE_GIT_LINK = "git::https://gitlab.alyans-auto.ru/pub/libvirt-node.git"`
