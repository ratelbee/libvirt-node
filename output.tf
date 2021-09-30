output "virtual_machines" {
  value =  merge(zipmap(libvirt_domain.virt_machine.*.name, libvirt_domain.virt_machine.*.network_interface.0.addresses.0)
     )
}
