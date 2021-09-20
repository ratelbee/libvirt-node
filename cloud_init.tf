data "template_file" "network_config" {
  count = var.vm_count
  template = file("${path.module}/templates/network_config_${var.dhcp == true ? "dhcp" : "static"}.tpl")
  vars = {
    ip_address = element(var.ip_address, count.index)
    ip_gateway = var.ip_gateway
    ip_nameservers = var.ip_nameservers
    nic = (var.share_filesystem.source == null ? "ens3" : "ens4")
    fqdn = var.fqdn
    # WA: If the shared filesystem is used, Libvirt connects Unclassified device to the 3rd position of PCI bus
  }
}

data "template_file" "init_config" {
  count = var.vm_count
  template = file("${path.module}/templates/ci_${var.srv_tpl}.tpl")
  vars = {
    ssh_admin = var.ssh_admin
    ssh_keys = var.ssh_keys
    local_admin = var.local_admin
    local_admin_passwd = var.local_admin_passwd
    hostname = format("${local.full_name}-%02d", count.index + var.index_start)
    fqdn = "${format("${local.full_name}-%02d", count.index + var.index_start)}.${var.fqdn}"
    time_zone = var.time_zone
  }
}

#locals {
  #keys = file("${path.module}/${var.ssh_keys}")
#  keys = var.ssh_keys
#}

data "template_cloudinit_config" "init_config" {
  count         = var.vm_count
  gzip          = false
  base64_encode = false

  part {
    filename     = format("init%02d.cfg", count.index + var.index_start)
    content_type = "text/cloud-config"
    content      = data.template_file.init_config[count.index].rendered
  }
}
