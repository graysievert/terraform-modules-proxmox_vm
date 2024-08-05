# Output variable definitions

output "vm_id" {
  description = "VM ID"
  value       = module.vm_example.vm_id
}

output "ipv4_addresses" {
  description = "IP v4 addresses"
  value       = module.vm_example.ipv4_addresses
}

output "ipv6_addresses" {
  description = "IP v6 addresses"
  value       = module.vm_example.ipv6_addresses
}

output "mac_addresses" {
  description = "MAC addresses"
  value       = module.vm_example.mac_addresses
}
