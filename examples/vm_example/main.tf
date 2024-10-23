
locals {
  node_name = "pve" #name of proxmox node"
  hostname  = "testhost"
  ssh_key   = var.public_ssh_key_for_VM
}

########################################
## Cloud-init custom configs
########################################


resource "proxmox_virtual_environment_file" "cloudinit_meta_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.node_name

  source_raw {
    file_name = "${local.hostname}-meta-config.yaml"
    data      = <<EOF
#cloud-config
local-hostname: ${local.hostname}
instance-id: ${md5(local.hostname)}
EOF
  }
}

resource "proxmox_virtual_environment_file" "cloudinit_user_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.node_name

  source_raw {
    file_name = "${local.hostname}-user-config.yaml"
    data      = <<EOF
#cloud-config
ssh_authorized_keys:
  - "${local.ssh_key}"
user:
  name: rocky
users:
  - default
EOF
  }
}

resource "proxmox_virtual_environment_file" "cloudinit_vendor_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.node_name

  source_raw {
    file_name = "${local.hostname}-vendor-config.yaml"
    data      = <<EOF
#cloud-config
packages:
    - qemu-guest-agent
runcmd:
  - echo "I am $(whoami) at $(hostname -f), myenv is \n $(printenv)"
EOF
  }
}

resource "proxmox_virtual_environment_file" "cloudinit_network_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.node_name

  source_raw {
    file_name = "${local.hostname}-network-config.yaml"
    data      = <<EOF
network:
  version: 2
  ethernets:
    # eth0:
    #   dhcp4: true
    eth0:
      dhcp4: no
      addresses:
       - 10.1.2.30/24
      nameservers:
        addresses: [10.1.2.100]
      routes:
        - to: 0.0.0.0/0
          via: 10.1.2.100
          metric: 100

EOF
  }
}



########################################
## Virtual Machine
########################################


module "vm_example" {
  source = "../.."

  metadata = {
    node_name    = local.node_name
    datastore_id = "local-zfs"
    image        = "local:iso/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2.img"
    agent        = true
    description  = "test vm"
    name         = local.hostname
    # pool_id      = "temp"
    tags         = ["test", "linux", "cloudinit"]
    # vm_id = 999
  }

  hardware = {
    mem_dedicated_mb = 2048
    mem_floating_mb  = 1024
    cpu_sockets      = 1
    cpu_cores        = 2
    disk_size_gb     = 15
  }

  cloudinit = {
    meta_config_file   = proxmox_virtual_environment_file.cloudinit_meta_config.id
    user_config_file   = proxmox_virtual_environment_file.cloudinit_user_config.id
    vendor_config_file = proxmox_virtual_environment_file.cloudinit_vendor_config.id
    # network_config_file = proxmox_virtual_environment_file.cloudinit_network_config.id

    ## Configuration via object below will produce cloud-init Networking Config Version 1
    ## If Networking Config Version 2 is required - use network_config_file instead
    ipv4 = {
      address = "dhcp" 
    }

    # ipv4 = {
    #   address = "dhcp" 
    #   nameservers = ["1.1.1.1","8.8.8.8"] # overrides whatever set via dhcp
    #   domain = "localdomain"              # overrides whatever set via dhcp
    # }

    # ipv4 = {
    #   address = "10.1.2.31/24"
    #   gateway = "10.1.2.100" 
    # }

    # ipv4 = {
    #   address = "10.1.2.31/24" 
    #   gateway = "10.1.2.100" 
    #   nameservers = ["1.1.1.1","8.8.8.8"]
    #   domain = "localdomain"
    # }

  }
}



