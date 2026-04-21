output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}

output "ecr_repo_url" {
  value = aws_ecr_repository.my_ecr.repository_url
}