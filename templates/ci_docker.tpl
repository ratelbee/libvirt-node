#cloud-config

packages:
  - qemu-guest-agent
  - vim
  - curl
  - docker
  - docker.io
  - docker-compose

hostname: ${hostname}
fqdn: ${fqdn}
manage_etc_hosts: true

users:
  - name: ${admin}
    gecos: CI User
    lock-passwd: false
    sudo: ALL=(ALL) NOPASSWD:ALL
    system: False
    ssh_authorized_keys: ${ssh_keys}
    shell: /bin/bash
chpasswd:
    list: |
        ${admin}:${passwd}
    expire: false

disable_root: true

write_files:
  - path: /etc/ssh/sshd_config
    content: |
         Port 22
         Protocol 2
         HostKey /etc/ssh/ssh_host_rsa_key
         HostKey /etc/ssh/ssh_host_dsa_key
         HostKey /etc/ssh/ssh_host_ecdsa_key
         HostKey /etc/ssh/ssh_host_ed25519_key
         UsePrivilegeSeparation yes
         KeyRegenerationInterval 3600
         ServerKeyBits 1024
         SyslogFacility AUTH
         LogLevel INFO
         LoginGraceTime 120
         PermitRootLogin no
         StrictModes yes
         RSAAuthentication yes
         PubkeyAuthentication yes
         IgnoreRhosts yes
         RhostsRSAAuthentication no
         HostbasedAuthentication no
         PermitEmptyPasswords no
         ChallengeResponseAuthentication no
         X11Forwarding yes
         X11DisplayOffset 10
         PrintMotd no
         PrintLastLog yes
         TCPKeepAlive yes
         AcceptEnv LANG LC_*
         Subsystem sftp /usr/lib/openssh/sftp-server
         UsePAM yes
         AllowUsers ${admin}

growpart:
    mode: auto
    devices:
      - "/"

resize_rootfs: true

timezone: ${time_zone}

runcmd:
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, qemu-guest-agent ]
  - [ systemctl, start, qemu-guest-agent ]
  - usermod -aG docker ${admin}
