resource "null_resource" "init_exec" {
  count = "${local.init_sp_scripts != "" && local.init_dp_scripts != "" && local.init_exec != "" ? var.vm_count : 0}"

  triggers = {
    before = libvirt_domain.virt_machine[count.index].id
  }

  provisioner "file" {
    source      = local.init_sp_scripts
    destination = local.init_dp_scripts

    when = create

    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      #timeout             = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [ local.init_exec ]

    when = create

    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      timeout             = "2m"
    }
 }

}

resource "null_resource" "apply_file" {
  count = "${var.apply_sp != "" && var.apply_dp != "" ? var.vm_count : 0}"

  triggers = {
      before = "${var.init_sp_scripts != "" && var.init_dp_scripts != "" && var.init_exec != "" ?
                null_resource.init_exec[count.index].id :
                libvirt_domain.virt_machine[count.index].id }"
  }

  provisioner "file" {
    source      = var.apply_sp
    destination = var.apply_dp
  
    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      #timeout             = "2m"
    }
  }

}


resource "null_resource" "apply_exec" {
  count = "${var.apply_exec != "" ? var.vm_count : 0}"

  triggers = {
      before = "${var.apply_sp != "" && var.apply_dp != "" ?
                null_resource.apply_file[count.index].id :
                libvirt_domain.virt_machine[count.index].id }"
  }

  provisioner "remote-exec" {
    inline = [ var.apply_exec ]

  connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      timeout             = "2m"
   }
 }

}

