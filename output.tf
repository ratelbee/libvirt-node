output "vm_static_ips" {
  value =  merge(zipmap(libvirt_domain.virt_machine.*.name, libvirt_domain.virt_machine.*.network_interface.0.addresses.0))
}
/*
output "vm_dynamic_ip" {

  value =  merge(zipmap(libvirt_domain.virt_machine.*.name, libvirt_domain.virt_machine.*.network_interface.0.addresses.0)
     )
}
*/
output "storage_size" {
  value = libvirt_volume.volume-qcow2.*.size
}