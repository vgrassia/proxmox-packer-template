# packer

Holds Hashicorp Packer files

## Setup

1. Create a `secrets.auto.pkrvars.hcl` file in the cloned directory.
1. Edit the secrets file and add in `proxmox_password = "password_here"` with your Proxmox user password.

## Build

1. `packer init -upgrade .`
1. `packer build .`