resource "aws_s3_bucket" "demo_bucket" {
    bucket = "alan-terraform-4182026"

    tags = {
        Name = "Demo Bucket"
    }
}