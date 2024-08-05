
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
    pool_id      = "temp"
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
    ipv4 = {
      address = "dhcp" # CIDR or "dhcp"
      #gateway = "" # not needed when "dhcp"
    }
  }
}



