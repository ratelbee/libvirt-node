# Libvirt Node Example
```
module "node" {
  source  = "git::https://gitlab.alyans-auto.ru/ops/libvirt-node.git"
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
  dhcp = false
  ip_address  = [
                  "10.20.100.183/24",
                  "10.20.100.184/24",
                  "10.20.100.185/24",
                  "10.20.100.186/24",
                ]
  ip_gateway  = "10.20.100.1"
  ip_nameservers = "'10.20.1.30', '10.20.0.30'"
  local_admin = "alyans"
  ssh_admin   = "alyans"
  #ssh_private_key = "~/.ssh/id_rsa"
  local_admin_passwd = "password"
  ssh_keys    = file("./id_rsa.pub")
  time_zone   = "Europe/Moscow"
  os_img_url  = "http://ubuntu-20.04-server-cloudimg-amd64.img"
  #hostname      = "runner"
  #ssh_private_key = "~/.ssh/id_rsa"
  
}

output "ip_addresses" {
  value = module.node
}
```

