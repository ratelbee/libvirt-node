resource "null_resource" "init_exec" {
  count = var.init_file_source_path != "" && var.init_file_target_path != "" && var.init_exec != "" ? var.vm_count : 0

  triggers = {
    before = libvirt_domain.virt_machine[count.index].id
  }

  provisioner "file" {
    source      = local.init_file_source_path
    destination = local.init_file_target_path

    connection {
      type                = "ssh"
      user                = var.admin
      host                = element(var.ip_address, count.index)
      private_key         = var.ssh_private_key
      timeout             = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [ file(local.init_exec) ]

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
  count = var.apply_file_source_path != "" && var.apply_file_target_path != "" ? var.vm_count : 0

  triggers = {
      always_run = timestamp()
      before = "${var.init_file_source_path != "" && var.init_file_target_path != "" && var.init_exec != "" ?
                  null_resource.init_exec[count.index].id :
                  libvirt_domain.virt_machine[count.index].id }"
  }

  provisioner "file" {
    source      = var.init_file_source_path
    destination = var.apply_file_target_path
  
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
  count = var.apply_exec != "" ? var.vm_count : 0

  triggers = {
    always_run = timestamp()
    before = "${var.init_file_source_path != "" && var.apply_file_target_path != "" ? null_resource.apply_file[count.index].id :
                var.init_file_source_path != "" && var.init_file_target_path != "" && var.init_exec != "" ?
                  null_resource.init_exec[count.index].id :
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

