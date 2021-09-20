version: 2
ethernets:
  ${nic}:
    dhcp4: false
    dhcp6: false
    addresses: [${ip_address}]
    gateway4: ${ip_gateway}
    nameservers:
       addresses: [${ip_resolv}]
       search: ['${fqdn}']
