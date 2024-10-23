# Proxmox VM out of cloud image

This module creates and launches a Pproxmox VM from a qcow2 cloud image.
The module expects the operational `bpg/proxmox` provider.
See `variables.tf`, `outputs.tf` and `examples` folder for description of input/output variables and usage.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=0.66.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >=0.66.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudinit"></a> [cloudinit](#input\_cloudinit) | <pre>VM cloud-init config:<br/>  meta\_config\_file: (optional) Cloud-init user config <br/>  user\_config\_file: (optional) Cloud-init vendor config <br/>  vendor\_config\_file: (optional) Cloud-init meta config<br/>  network\_config\_file: (optional) Cloud-init meta config (overrides `ipv4`)<br/>  ipv4: (optional) ip v4 cloud-init network configuration object. <br/>      address: CIDR or "dhcp"<br/>      gateway: (optional) IP address, must be omitted when "dhcp" is used<br/>      namesevers: (optional) list of IP addresses (e.g. ["1.1.1.1", "8.8.8.8"]),<br/>                  if not set proxmox default is used<br/>      domain: (optional) search domain (e.g. "lan"), <br/>              if not set proxmox default is used<br/>  [NOTE] If set, ipv4 object will produce cloud-init Networking Config Version 1. <br/>         If Networking Config Version 2 (or/and complex configuration) is required,<br/>         then use `network_config_file` instead</pre> | <pre>object({<br/>    meta_config_file     = optional(string)<br/>    user_config_file     = optional(string)<br/>    vendor_config_file   = optional(string)<br/>    network_config_file  = optional(string)<br/>    ipv4 = optional(object({<br/>      address = string             # (e.g. "192.168.2.2/24" or "dhcp")<br/>      gateway = optional(string)   # must be omitted when dhcp is used as the address<br/>      nameservers = optional(list(string)) # (e.g. ["1.1.1.1", "8.8.8.8"])<br/>      domain = optional(string)    # search domain(e.g. "lan")<br/>    }))<br/>  })</pre> | <pre>{<br/>  "ipv4": {<br/>    "address": "dhcp",<br/>    "domain": null,<br/>    "gateway": null,<br/>    "nameservers": null<br/>  },<br/>  "meta_config_file": null,<br/>  "user_config_file": null,<br/>  "vendor_config_file": null<br/>}</pre> | no |
| <a name="input_hardware"></a> [hardware](#input\_hardware) | <pre>VM hardware config:<br/>    mem\_dedicated\_mb: max memory<br/>    mem\_floating\_mb: min memory<br/>    cpu\_sockets: No of CPU sockets<br/>    cpu\_cores: No of CPU cores<br/>    disk\_size\_gb: size of VM disk</pre> | <pre>object({<br/>    mem_dedicated_mb = number<br/>    mem_floating_mb  = number<br/>    cpu_sockets      = number<br/>    cpu_cores        = number<br/>    disk_size_gb     = number<br/>  })</pre> | <pre>{<br/>  "cpu_cores": 2,<br/>  "cpu_sockets": 1,<br/>  "disk_size_gb": 15,<br/>  "mem_dedicated_mb": 2048,<br/>  "mem_floating_mb": 1024<br/>}</pre> | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | <pre>VM essential info:<br/>  node\_name: The name of the node to assign the virtual machine to.<br/>  datastore\_id: default is "local-zfs"<br/>  image: path to a cloud image in a format `storage:content/imagefile` <br/>  agent: The QEMU agent configuration. True/False<br/>  description: The virtual machine description.<br/>  name: The virtual machine name.<br/>  pool\_id: The identifier for a pool to assign the virtual machine to.<br/>  tags: A list of tags of the VM.<br/>  vm\_id: The VM identifier.</pre> | <pre>object({<br/>    node_name    = string<br/>    datastore_id = string<br/>    image        = string<br/>    agent        = optional(bool)<br/>    description  = optional(string)<br/>    name         = optional(string)<br/>    pool_id      = optional(string)<br/>    tags         = optional(list(string))<br/>    vm_id        = optional(number)<br/>  })</pre> | <pre>{<br/>  "agent": false,<br/>  "datastore_id": "local-zfs",<br/>  "description": null,<br/>  "image": "local:iso/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2.img",<br/>  "name": null,<br/>  "node_name": null,<br/>  "pool_id": null,<br/>  "tags": [],<br/>  "vm_id": null<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipv4_addresses"></a> [ipv4\_addresses](#output\_ipv4\_addresses) | IP v4 addresses |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | IP v6 addresses |
| <a name="output_mac_addresses"></a> [mac\_addresses](#output\_mac\_addresses) | MAC addresses |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | VM ID |
