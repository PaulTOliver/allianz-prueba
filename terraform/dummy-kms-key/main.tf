# -------------------------------------------------------------
# Éste módulo define una llave KMS de prueba para uso de éste ejercicio.
# -------------------------------------------------------------

# Proveedor de prueba para uso con MiniStack
provider "aws" {
  region                      = "eu-central-1"
  access_key                  = "111111111111"
  secret_key                  = "111111111111"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    kms = "http://localhost:4566"
  }
}

resource "aws_kms_key" "backup_vault_kms_key" {
  description = "Dummy KSM key para uso en este ejercicio"
}

resource "aws_kms_alias" "backup_vault_kms_alias" {
  name          = "alias/BackupVaultKey"
  target_key_id = aws_kms_key.backup_vault_kms_key.id
}
