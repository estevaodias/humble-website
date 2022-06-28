data "archive_file" "build" {
  source_dir       = "${path.module}/../dist/humble-website"
  output_file_mode = "0666"
  output_path      = "${path.module}/.temp/build.zip"
  type             = "zip"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "humble-website"
  force_destroy = true

  tags = {
    Environment = var.humble_environment
    Name        = "Humble Website"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  acl    = "private"
  bucket = aws_s3_bucket.bucket.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  etag   = filemd5(data.archive_file.build.output_path)
  key    = "v${var.humble_version}/${aws_s3_bucket.bucket.id}.zip"
  source = data.archive_file.build.output_path
}
