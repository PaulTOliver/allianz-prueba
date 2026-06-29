# -------------------------------------------------------------
# Configuración de nuestro módulo
# -------------------------------------------------------------

variable "backup_vault_kms_alias_name" {
  description = "Alias de llave KSM a utilizar para encriptación de vaults"
  type        = string
}

variable "backup_vault_name" {
  description = "Nombre para los vaults" # posible mejora: usar un nombre distinto para cada vault
  type        = string
}

variable "backup_schedule" {
  description = "Expresión CRON que especifica nuestro intérvalo de generación de respaldos"
  type        = string
}

variable "backup_vault_lock_max_retention_days" {
  description = "Máximo número de días que la vault mantiene sus puntos de recuperación"
  type        = number
}

variable "backup_vault_lock_min_retention_days" {
  description = "Mínimo número de días que la vault mantiene sus puntos de recuperación"
  type        = number
}

variable "backup_owner_tag" {
  description = "Etiqueta identificativa de recursos a respaldar"
  type        = string
}
