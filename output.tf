output "virtual_machines" {
  value =  merge(zipmap(libvirt_domain.virt-machine.*.name, libvirt_domain.virt-machine.*.network_interface.0.addresses.0)
     )
}
