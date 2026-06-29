# -------------------------------------------------------------
# Ejemplo de utilización del módulo
# -------------------------------------------------------------

module "cross_account_vault" {
  source = "../modules/cross-account-vault"

  # Tres proveedores pre-configurados
  # - prod-eu-central -> Frankfurt, cuenta `prod`
  # - prod-eu-west    -> Ireland,   cuenta `prod`
  # - backup          -> Frankfurt, cuenta `backup`
  providers = {
    aws.prod-eu-central = aws.prod-eu-central
    aws.prod-eu-west    = aws.prod-eu-west
    aws.backup          = aws.backup
  }

  # Usaremos el alias para identificar la KSM key a utilizar
  backup_vault_kms_alias_name = "alias/BackupVaultKey"

  backup_vault_name = "vault-multi-cuenta"
  backup_schedule   = "cron(0 0 * * *)" # se generará un backup al día

  backup_vault_lock_max_retention_days = 1200
  backup_vault_lock_min_retention_days = 7

  backup_owner_tag = "owner@eulerhermes.com"
}
