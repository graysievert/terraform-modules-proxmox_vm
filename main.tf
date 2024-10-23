
locals {
  metadata  = var.metadata
  hardware  = var.hardware
  cloudinit = var.cloudinit
}


resource "proxmox_virtual_environment_vm" "vm" {
  description = local.metadata.description
  tags        = local.metadata.tags
  name        = local.metadata.name
  node_name   = local.metadata.node_name
  vm_id       = local.metadata.vm_id
  pool_id     = local.metadata.pool_id
  started     = true
  on_boot     = true

  agent {
    enabled = local.metadata.agent
    timeout = "15m"
    trim    = false
    type    = "virtio"
  }

  ## cloud-init section.
  initialization {
    datastore_id = local.metadata.datastore_id

    ## User config yaml
    user_data_file_id = local.cloudinit.user_config_file
    ## Vendor config yaml
    vendor_data_file_id = local.cloudinit.vendor_config_file
    ## Metadata config yaml
    meta_data_file_id = local.cloudinit.meta_config_file
    ## Network config yaml (overrides parameter-way configuration if such is present)
    network_data_file_id = local.cloudinit.network_config_file
    
    ## Network config as parameters (wil be overwritten by yaml network config if such is present) 
    dns {
      servers = local.cloudinit.ipv4 != null ? local.cloudinit.ipv4.nameservers : null
      domain  = local.cloudinit.ipv4 != null ? local.cloudinit.ipv4.domain : null
    }
    ip_config {
      ipv4 {
        address = local.cloudinit.ipv4 != null ? local.cloudinit.ipv4.address : "dhcp"
        gateway = local.cloudinit.ipv4 != null ? local.cloudinit.ipv4.gateway : null
      }
    }
  }

  ## VM parameters.
  acpi       = true
  bios       = "ovmf"
  boot_order = ["scsi0"]
  machine    = "q35"
  operating_system {
    type = "l26"
  }
  efi_disk {
    datastore_id      = local.metadata.datastore_id
    file_format       = "raw"
    type              = "4m"
    pre_enrolled_keys = false
  }
  tpm_state {
    datastore_id = local.metadata.datastore_id
    version      = "v2.0"
  }


  memory {
    dedicated = local.hardware.mem_dedicated_mb
    floating  = local.hardware.mem_floating_mb
    shared    = 0
  }

  cpu {
    architecture = "x86_64"
    type         = "host"
    hotplugged   = 0
    limit        = 0
    units        = 1024
    numa         = false
    sockets      = local.hardware.cpu_sockets
    cores        = local.hardware.cpu_cores
  }

  scsi_hardware = "virtio-scsi-single"
  disk {
    datastore_id = local.metadata.datastore_id
    aio          = "native"
    backup       = true
    cache        = "none"
    discard      = "ignore"
    file_format  = "raw"
    file_id      = local.metadata.image
    interface    = "scsi0"
    iothread     = true
    replicate    = true
    ssd          = false
    size         = local.hardware.disk_size_gb
  }

  serial_device {
    device = "socket"
  }

  tablet_device = false
  vga {
    type = "serial0"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    mtu    = 1
  }

  lifecycle {
    ignore_changes = [
      # vm_id,
      # id,
      # name,
      # tags,
      # cpu,
      # template,
      # initialization
    ]
  }

}
