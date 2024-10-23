terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.66.2"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://pve.lan:8006/"
  api_token = var.pvetoken

  ssh {
    agent    = true
    username = var.pveusername
  }
}
