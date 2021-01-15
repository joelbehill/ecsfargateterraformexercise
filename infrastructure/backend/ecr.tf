resource "aws_ecr_repository" "ecr" {
  name                 = "express"
  image_tag_mutability = "MUTABLE"
}

output "ecr" {
  value = aws_ecr_repository.ecr.repository_url
}