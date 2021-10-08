version: 2
ethernets:
  ${nic}:
    dhcp4: false
    dhcp6: false
    addresses: [${ip_address}/${ip_netmask}]
    gateway4: ${ip_gateway}
    nameservers:
       addresses: [${ip_resolve}]
       search: ['${ip_domain}']
