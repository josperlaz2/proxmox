// main.tf (dentro de la carpeta terraform/)
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.8.0" # Asegúrate de que esta versión sea compatible con tu Proxmox
    }
  }
}

provider "proxmox" {
  pm_api_url = var.api_url           # Terraform espera el valor de var.api_url
  pm_api_token_id = var.token_id     # Terraform espera el valor de var.token_id
  pm_api_token_secret = var.token_secret # Terraform espera el valor de var.token_secret
  pm_tls_insecure = true             # Solo para entornos de prueba
}

resource "proxmox_lxc" "ct1" {
  target_node = "pve" # Nombre de tu nodo Proxmox (ej. "pve")
  hostname    = "jenkins-demo" # Nombre del host para el contenedor
  // ASEGÚRATE de que esta plantilla existe EXACTAMENTE en tu Proxmox
  ostemplate  = "local:vztmpl/debian-11-standard_11.7-1_amd64.tar.gz_tmp_dwnl.3573"
  password    = "123456" # Contraseña para el usuario root del contenedor (solo para pruebas, NO para producción)
  cores       = 2
  memory      = 1024 # MB
  swap        = 512 # MB
  net0 {
    name = "eth0"
    bridge = "vmbr0" # El bridge de red de tu Proxmox (ej. vmbr0, vmbr1)
    ip = "dhcp"      # Asignación de IP por DHCP
    type = "veth"
  }
  rootfs {
    storage = "local-lvm" # Almacenamiento en Proxmox (ej. "local-lvm", "local")
    size    = "4G"
  }
}
