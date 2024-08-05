# Output variable definitions

output "vm_id" {
  description = "VM ID"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "ipv4_addresses" {
  description = "IP v4 addresses"
  value       = flatten(slice(proxmox_virtual_environment_vm.vm.ipv4_addresses, 1, length(proxmox_virtual_environment_vm.vm.ipv4_addresses)))
}

output "ipv6_addresses" {
  description = "IP v6 addresses"
  value       = flatten(slice(proxmox_virtual_environment_vm.vm.ipv6_addresses, 1, length(proxmox_virtual_environment_vm.vm.ipv6_addresses)))
}

output "mac_addresses" {
  description = "MAC addresses"
  value       = flatten(slice(proxmox_virtual_environment_vm.vm.mac_addresses, 1, length(proxmox_virtual_environment_vm.vm.mac_addresses)))
}
