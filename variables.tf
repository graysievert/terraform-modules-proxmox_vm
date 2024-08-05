# Input variable definitions

variable "metadata" {
  description = <<EOF
VM essential info:
  node_name: The name of the node to assign the virtual machine to.
  datastore_id: default is "local-zfs"
  image: path to a cloud image in a format `storage:content/imagefile` 
  agent: The QEMU agent configuration. True/False
  description: The virtual machine description.
  name: The virtual machine name.
  pool_id: The identifier for a pool to assign the virtual machine to.
  tags: A list of tags of the VM.
  vm_id: The VM identifier.
EOF
  type = object({
    node_name    = string
    datastore_id = string
    image        = string
    agent        = optional(bool)
    description  = optional(string)
    name         = optional(string)
    pool_id      = optional(string)
    tags         = optional(list(string))
    vm_id        = optional(number)
  })
  default = {
    node_name    = null
    datastore_id = "local-zfs"
    image        = "local:iso/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2.img"
    agent        = false
    description  = null
    name         = null
    pool_id      = null
    tags         = []
    vm_id        = null
  }

}

variable "hardware" {
  description = <<EOF
  VM hardware config:
    mem_dedicated_mb: max memory
    mem_floating_mb: min memory
    cpu_sockets: No of CPU sockets
    cpu_cores: No of CPU cores
    disk_size_gb: size of VM disk
  EOF
  type = object({
    mem_dedicated_mb = number
    mem_floating_mb  = number
    cpu_sockets      = number
    cpu_cores        = number
    disk_size_gb     = number
  })
  default = {
    mem_dedicated_mb = 2048
    mem_floating_mb  = 1024
    cpu_sockets      = 1
    cpu_cores        = 2
    disk_size_gb     = 15
  }
}


variable "cloudinit" {
  description = <<EOF
VM cloud-init config:
  meta_config_file: (optional) Cloud-init user config 
  user_config_file: (optional) Cloud-init vendor config 
  vendor_config_file: (optional) Cloud-init meta config
  ipv4: (optional) ip v4 configuration object
EOF
  type = object({
    meta_config_file   = optional(string)
    user_config_file   = optional(string)
    vendor_config_file = optional(string)
    ipv4 = optional(object({
      address = string           # (e.g. 192.168.2.2/24)
      gateway = optional(string) # must be omitted when dhcp is used as the address
    }))
  })

  default = {
    meta_config_file   = null
    user_config_file   = null
    vendor_config_file = null
    ipv4 = {
      address = "dhcp"
      gateway = null
    }
  }
}