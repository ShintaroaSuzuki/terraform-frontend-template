resource "aws_s3_bucket" "for_client" {
  bucket_prefix = "${var.env_name}-example"
}

resource "aws_s3_object" "multiple_object" {
  for_each     = module.distribution_files.files
  bucket       = aws_s3_bucket.for_client.id
  key          = each.key
  source       = each.value.source_path
  content_type = each.value.content_type
  etag         = filemd5(each.value.source_path)
}

resource "aws_s3_bucket_acl" "for_client_acl" {
  bucket = aws_s3_bucket.for_client.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "for_client" {
  bucket = aws_s3_bucket.for_client.id
  policy = data.aws_iam_policy_document.for_client.json
}

data "aws_iam_policy_document" "for_client" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.for_client.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.for_client.arn}/*"
    ]
  }
}

module "distribution_files" {
  source   = "hashicorp/dir/template"
  base_dir = "../../../app/build"
}
