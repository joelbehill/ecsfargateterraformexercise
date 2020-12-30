# I don't feel comfortable adding this dynamodb which contains the terraform lock to terraform...
# in case I make a mistake.
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "hill-cc-terraform-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
      name = "LockID"
      type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }

  lifecycle {
    ignore_changes = [
    ]
  }
}
