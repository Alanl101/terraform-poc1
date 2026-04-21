resource "aws_ecr_repository" "my_ecr" {
  name = "terraform-poc1-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = "dev"
    Project     = "terraform-poc1"
  }
}

resource "aws_ecr_lifecycle_policy" "my_ecr" {
  repository = aws_ecr_repository.my_ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}