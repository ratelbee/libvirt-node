output "vm_static_ips" {
  value =  libvirt_domain.virt_machine.*.network_interface.0.addresses.0 ? merge(zipmap(libvirt_domain.virt_machine.*.name, libvirt_domain.virt_machine.*.network_interface.0.addresses.0)) : null
}

output "storage_size" {
  value = libvirt_volume.volume-qcow2.*.size
}