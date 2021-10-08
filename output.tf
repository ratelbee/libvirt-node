output "virtual_machines" {
  value =  merge(zipmap(libvirt_domain.virt_machine.*.name, libvirt_domain.virt_machine.*.network_interface.0.addresses.0)
     )
}

output "storage_size" {
  value = libvirt_volume.volume-qcow2.*.size
}

output "mac_address" {
  value = libvirt_domain.virt_machine.*.network_interface.0.nic.0.addresses.0
}