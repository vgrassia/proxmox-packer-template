packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

build {
  name = "proxmox"

  source "source.proxmox-iso.ubuntu-2004" {
    node        = "proxmox-node-name"
    proxmox_url = "https://proxmox-node.local:8006/api2/json"
    disks {
      format            = "raw"
      disk_size         = "20G"
      storage_pool      = "storage-pool-name"
      storage_pool_type = "lvm-thin"
      type              = "scsi"
    }
    network_adapters {
      bridge      = "vmbr0"
      firewall    = false
      mac_address = "2f:bd:83:8b:c4:65"
      model       = "virtio"
    }
  }
}

source "proxmox-iso" "ubuntu-2004" {
  insecure_skip_tls_verify = true
  username                 = "packer@pve"
  password                 = var.proxmox_password
  iso_url                  = "https://releases.ubuntu.com/20.04.6/ubuntu-20.04.6-live-server-amd64.iso"
  iso_storage_pool         = "local"
  iso_checksum             = "sha256:b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
  vm_name                  = "ubuntu-2004-template"
  vm_id                    = "1000"
  memory                   = 1024
  cores                    = 1
  os                       = "l26"
  template_description     = "Ubuntu 20.04 image"
  unmount_iso              = true
  onboot                   = true
  qemu_agent               = true
  scsi_controller          = "virtio-scsi-pci"
  boot_command = [
    "<esc><wait><wait>",
    "install ",

    "auto=true ",
    "priority=critical ",
    "interface=auto ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",

    "passwd/user-fullname=Packer ",
    "passwd/user-password=packer ",
    "passwd/user-password-again=packer ",
    "passwd/username=packer ",

    "<enter>"
  ]

  http_directory = "http"
  http_interface = "Ethernet"

  ssh_username = "packer"
  ssh_timeout  = "15m"
  ssh_password = "packer"
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}
