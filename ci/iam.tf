data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]

    principals {
      identifiers = [
        aws_cloudfront_origin_access_identity.origin.iam_arn
      ]
      type = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.policy.json
}
