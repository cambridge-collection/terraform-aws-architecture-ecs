resource "aws_s3_bucket" "this" {
  count = var.s3_bucket_create ? 1 : 0

  bucket        = var.s3_bucket_name != null ? var.s3_bucket_name : var.name_prefix
  force_destroy = var.s3_bucket_force_destroy
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.s3_bucket_create ? 1 : 0

  bucket = aws_s3_bucket.this.0.id
  versioning_configuration {
    status = var.s3_bucket_versioning_enabled ? "Enabled" : "Disabled"
  }
}
