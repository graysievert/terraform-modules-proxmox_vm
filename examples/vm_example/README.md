# Example: Rocky Linux VM with cloud-init configuration

This example provisions 4 resources:
- `proxmox_virtual_environment_file.cloudinit_user_config`
- `proxmox_virtual_environment_file.cloudinit_vendor_config`
- `proxmox_virtual_environment_file.cloudinit_meta_config`
- `module.vm_example.proxmox_virtual_environment_vm.vm`

Example files expect that:
- Environment variable `TF_VAR_pvetoken` is set - Proxmox API token for TF to use
- Environment variable `TF_VAR_public_ssh_key_for_VM` is set - Public SSH key to use in cloud-init config for test VM
- SSH user is `iac` (set by `pveusername` tf variable)
- Proxmox API is available at `https://pve.lan:8006/` (set in `provider.tf`)
- Image `Rocky-9-GenericCloud-Base.latest.x86_64.qcow2.img` is present on the Proxmox node

For more details about configuration look here: [Configuring Proxmox VE to be managed via Terraform](https://github.com/graysievert/Homelab-020_Proxmox_basic/tree/master/130-Terraform_access)
