# -------------------------------------------------------------
# Proveedores de prueba permiten testar este código Terraform
# en un PC que este corriendo MiniStack:
# https://ministack.org/
#
# En un escenario real, configuraremos estos proveedores
# para representar nuestras cuentas reales de producción (`prod`)
# y respaldo (`backup`).
# -------------------------------------------------------------

# Prod account - Frankfurt
provider "aws" {
  alias                       = "prod-eu-central"
  region                      = "eu-central-1"
  access_key                  = "111111111111"
  secret_key                  = "111111111111"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    backup = "http://localhost:4566"
    iam    = "http://localhost:4566"
    kms    = "http://localhost:4566"
    sts    = "http://localhost:4566"
  }
}

# Prod account - Ireland
provider "aws" {
  alias                       = "prod-eu-west"
  region                      = "eu-west-1"
  access_key                  = "111111111111"
  secret_key                  = "111111111111"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    backup = "http://localhost:4566"
    iam    = "http://localhost:4566"
    kms    = "http://localhost:4566"
    sts    = "http://localhost:4566"
  }
}

# Backup account - Frankfurt
provider "aws" {
  alias                       = "backup"
  region                      = "eu-central-1"
  access_key                  = "222222222222"
  secret_key                  = "222222222222"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    backup = "http://localhost:4566"
    iam    = "http://localhost:4566"
    kms    = "http://localhost:4566"
    sts    = "http://localhost:4566"
  }
}
