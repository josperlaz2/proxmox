// variables.tf (dentro de la carpeta terraform/)
variable "api_url" {
  description = "https://192.168.0.176:8006/api2/json"
  type        = string
}

variable "token_id" {
  description = "root@pam!jenkins"
  type        = string
  sensitive   = true # Marca como sensible para que no aparezca en la salida de plan/apply
}

variable "token_secret" {
  description = "93e7002a-7031-4e62-ba17-9bf3f5fd3b16"
  type        = string
  sensitive   = true # Marca como sensible
}
