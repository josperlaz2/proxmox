terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.8.0" # Asegúrate de que esta versión sea compatible
    }
  }
}

provider "proxmox" {
  pm_api_url = var.api_url
  pm_api_token_id = var.token_id
  pm_api_token_secret = var.token_secret
  pm_tls_insecure = true # Solo para entornos de prueba, no recomendado en producción sin SSL/TLS válido
}

resource "proxmox_lxc" "ct1" {
  target_node = "pve" # Nombre de tu nodo Proxmox (ej. "pve")
  hostname    = "jenkins-demo" # Nombre del host para el contenedor
  ostemplate  = "local:vztmpl/debian-11-standard_11.7-1_amd64.tar.gz_tmp_dwnl.3573" # La plantilla de SO que tienes disponible en Proxmox
  password    = "123456" # Contraseña para el usuario root del contenedor (solo para pruebas)
  cores       = 2
  memory      = 1024 # MB
  swap        = 512 # MB
  net0 {
    name = "eth0"
    bridge = "vmbr0" # El bridge de red de tu Proxmox
    ip = "dhcp" # Asignación de IP por DHCP
    type = "veth"
  }
  rootfs {
    storage = "local-lvm" # almacenamiento en Proxmox (ej. "local-lvm", "local")
    size    = "4G"
  }
}
