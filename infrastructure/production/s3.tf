# I don't feel comfortable adding this dynamodb which contains the terraform lock to terraform...
# in case I make a mistake.
resource "aws_s3_bucket" "terraform_lock" {
  bucket = "joelhill-terraform-state"
  versioning {
      enabled = true
  }
  server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
          }
      }
  }
  object_lock_configuration {
      object_lock_enabled = "Enabled"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "S3 Remote Terraform State Store"
    },
  )
}