data "template_file" "network_config" {
  count = var.vm_count
  template = file("${path.module}/templates/network_config_${var.dhcp == true ? "dhcp" : "static"}.tpl")
  vars = {
    ip_address = element(var.ip_address, count.index)
    ip_gateway = var.ip_gateway
    ip_resolve = var.ip_resolve
    ip_netmask = var.ip_netmask
    nic = local.nic
    ip_domain = var.ip_domain != "" ? var.ip_domain : var.fqdn != "" ? var.fqdn : ""
    # WA: If the shared filesystem is used, Libvirt connects Unclassified device to the 3rd position of PCI bus
  }
}

data "template_file" "init_config" {
  count = var.vm_count
  template = file("${var.custom_template != "" ? var.custom_template : local.defined_template}")
  vars = {
    admin = var.admin
    ssh_keys = var.ssh_keys
    passwd = var.passwd
    hostname = format("${local.full_name}-%02d", count.index + var.index_start)
    full_name = local.full_name
    fqdn = "${format("${local.full_name}-%02d", count.index + var.index_start)}.${var.fqdn}"
    time_zone = var.time_zone
    count_index = format("%02d", count.index + var.index_start)
  }
}

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
