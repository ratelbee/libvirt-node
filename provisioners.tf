resource "null_resource" "init_exec" {
  count = "${var.init_sp_scripts != "" && var.init_dp_scripts && var.init_exec != "" ? var.vm_count : 0}"

  triggers = {
    before = libvirt_domain.virt_machine[count.index].id
  }

  provisioner "file" {
    source      = var.init_sp_scripts
    destination = var.init_dp_scripts

    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      #timeout             = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [ var.init_exec ]

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

  when = apply

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

  when = apply

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

