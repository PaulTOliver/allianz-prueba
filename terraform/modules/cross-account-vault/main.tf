terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [
        aws.prod-eu-central,
        aws.prod-eu-west,
        aws.backup,
      ]
    }
  }
}

# -------------------------------------------------------------
# Seleccionamos la llave KSM a usar segun su alias
# La llave única existirá en la cuenta `prod`.
# -------------------------------------------------------------
data "aws_kms_alias" "backup_vault_kms_alias" {
  provider = aws.prod-eu-central
  name     = var.backup_vault_kms_alias_name
}

# -------------------------------------------------------------
# Creamos tres vaults:
# - Frankfurt -> cuenta `prod`
# - Irlanda   -> cuenta `prod`
# - Frankfurt -> cuenta `backup`
# -------------------------------------------------------------
resource "aws_backup_vault" "backup_vault_prod_eu_central" {
  provider    = aws.prod-eu-central
  name        = var.backup_vault_name
  kms_key_arn = data.aws_kms_alias.backup_vault_kms_alias.target_key_arn
}

resource "aws_backup_vault" "backup_vault_prod_eu_west" {
  provider    = aws.prod-eu-west
  name        = var.backup_vault_name
  kms_key_arn = data.aws_kms_alias.backup_vault_kms_alias.target_key_arn
}

resource "aws_backup_vault" "backup_vault_backup" {
  provider    = aws.backup
  name        = var.backup_vault_name
  kms_key_arn = data.aws_kms_alias.backup_vault_kms_alias.target_key_arn
}

# -------------------------------------------------------------
# Aplicaremos Vault Lock a las tres vaults tal como se
# especifica en los requisitos.
# -------------------------------------------------------------
resource "aws_backup_vault_lock_configuration" "backup_vault_lock_configuration_prod_eu_central" {
  provider           = aws.prod-eu-central
  backup_vault_name  = var.backup_vault_name
  max_retention_days = var.backup_vault_lock_max_retention_days
  min_retention_days = var.backup_vault_lock_min_retention_days
}

resource "aws_backup_vault_lock_configuration" "backup_vault_lock_configuration_prod_eu_west" {
  provider           = aws.prod-eu-west
  backup_vault_name  = var.backup_vault_name
  max_retention_days = var.backup_vault_lock_max_retention_days
  min_retention_days = var.backup_vault_lock_min_retention_days
}

resource "aws_backup_vault_lock_configuration" "backup_vault_lock_configuration_backup" {
  provider           = aws.backup
  backup_vault_name  = var.backup_vault_name
  max_retention_days = var.backup_vault_lock_max_retention_days
  min_retention_days = var.backup_vault_lock_min_retention_days
}

# -------------------------------------------------------------
# Generamos un único backup-plan
# -------------------------------------------------------------
resource "aws_backup_plan" "cross_account_backup_plan" {
  provider = aws.prod-eu-central
  name     = "Plan de backup multi-cuenta"

  rule {
    rule_name         = "Regla de backup multi-cuenta"
    target_vault_name = var.backup_vault_name
    schedule          = var.backup_schedule

    # Haremos un duplicado de la vault principal en dos lugares adicionales:
    # - Irlanda   -> cuenta `prod`
    # - Frankfurt -> cuenta `backup`
    copy_action { destination_vault_arn = aws_backup_vault.backup_vault_prod_eu_west.arn }
    copy_action { destination_vault_arn = aws_backup_vault.backup_vault_prod_eu_west.arn }
  }
}

# -------------------------------------------------------------
# Un único backup-selection.
# Por defecto AWS selecciona todos los recursos respaldables.
# Utilizamos 2 etiquetas para filtrar los recursos de interés.
# -------------------------------------------------------------
resource "aws_backup_selection" "cross_account_backup_selection" {
  provider     = aws.prod-eu-central
  iam_role_arn = aws_iam_role.ejercicio.arn
  name         = "resource-selection"
  plan_id      = aws_backup_plan.cross_account_backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ToBackup"
    value = "true"
  }

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Owner"
    value = var.backup_owner_tag
  }
}
