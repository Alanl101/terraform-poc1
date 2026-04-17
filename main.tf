resource "aws_s3_bucket" "demo_bucket" {
    bucket = "alan-terraform-4172026"

    tags = {
        Name = "Demo Bucket"
    }
}