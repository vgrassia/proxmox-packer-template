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

  source "source.proxmox-iso.debian-11" {
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

source "proxmox-iso" "debian-11" {
  insecure_skip_tls_verify = true
  username                 = "packer@pve"
  password                 = var.proxmox_password
  iso_url                  = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso"
  iso_storage_pool         = "local"
  iso_checksum             = "sha512:224cd98011b9184e49f858a46096c6ff4894adff8945ce89b194541afdfd93b73b4666b0705234bd4dff42c0a914fdb6037dd0982efb5813e8a553d8e92e6f51"
  vm_name                  = "debian-11-template"
  vm_id                    = "1000"
  memory                   = 1024
  cores                    = 1
  os                       = "l26"
  template_description     = "Debian 11 Bullseye image"
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
