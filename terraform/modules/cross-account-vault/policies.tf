# -------------------------------------------------------------
# IAM Role de prueba - necesario para crear nuestro backup-selection.
# -------------------------------------------------------------

data "aws_iam_policy_document" "assume_role" {
  provider = aws.prod-eu-central

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ejercicio" {
  provider           = aws.prod-eu-central
  name               = "ejercicio"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ejercicio" {
  provider   = aws.prod-eu-central
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.ejercicio.name
}
