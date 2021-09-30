terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.6.10"
      }
    }
}

resource "libvirt_domain" "virt-machine" {
  count      = var.vm_count
  name       = format("${local.full_name}-%02d", count.index + var.index_start)
  memory     = var.memory
  vcpu       = var.vcpu
  autostart  = var.autostart
  qemu_agent = true
  cloudinit  = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)
  cpu        = {  mode = "host-passthrough"  }

  network_interface {
    bridge         = var.bridge
    wait_for_lease = var.dhcp == true ? true : false
    hostname       = format("${local.full_name}-%02d", count.index + var.index_start)
    addresses      = ["${element(var.ip_address, count.index)}"]
  }

  xml {
    xslt = (var.hugepages == true ? file("${path.module}/xslt/hugepages.xsl") : null)
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = element(libvirt_volume.volume-qcow2.*.id, count.index)
  }

  dynamic "filesystem" {
    for_each = var.share_filesystem.source != null ? [ var.share_filesystem.source] : []
    content {
      source     = var.share_filesystem.source
      target     = var.share_filesystem.target
      readonly   = var.share_filesystem.readonly
      accessmode = var.share_filesystem.mode
    }
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
  
}

resource "null_resource" "file" {
  count = "${var.sp_scripts != "" && var.dp_scripts != "" ? var.vm_count : 0}"
  depends_on = [ libvirt_domain.virt-machine ]

  provisioner "file" {
    source      = var.sp_scripts
    destination = var.dp_scripts

    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      #timeout             = "2m"
    }
  }

}

resource "null_resource" "exec" {
  count = "${var.remote_exec != "" ? var.vm_count : 0}"

  triggers = {
    before = "${var.sp_scripts != "" && var.dp_scripts != "" ?
                null_resource.file[count.index].id :
                libvirt_domain.virt-machine[count.index].id }"
  }

  provisioner "remote-exec" {
    inline = [ var.remote_exec ]

  connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      timeout             = "2m"
   }
 }

}

