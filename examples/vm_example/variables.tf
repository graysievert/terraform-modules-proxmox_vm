variable "pveusername" {
  description = "PAM username for ssh use"
  type        = string
  default     = "iac"
}

variable "pvetoken" {
  description = "Proxmox API token for TF to use"
  type        = string
  ## see readme for setting token via shell variable
}

variable "public_ssh_key_for_VM" {
  description = "Public ssh key to use in cloud-init config for test vm"
  type        = string
  ## see readme for setting token via shell variable
}
