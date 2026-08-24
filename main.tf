resource "aws_ecr_repository" "anpupu" {
  name                 = "anpupu"
  image_tag_mutability = "IMMUTABLE" # MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_policy" {
  repository = aws_ecr_repository.anpupu.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["main"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

