resource "aws_s3_bucket" "resultbucket" {
  bucket = "result-${random_id.rando.hex}"
  versioning {
    enabled = true
  }

  acl  = "private"
  tags = local.common-tags
  depends_on = [
    aws_lambda_function.parse,
    aws_lambda_function.extract
  ]
}

resource "aws_s3_bucket_notification" "resultbucket_notification" {
  bucket = aws_s3_bucket.resultbucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.parse.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "result/"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.extract.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "input/"
    filter_suffix       = ".png"
  }

}

resource "aws_s3_bucket_public_access_block" "result-block-public" {
  bucket                  = aws_s3_bucket.resultbucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket" "resultbucket1" {
  bucket = "result1-${random_id.rando.hex}"
  versioning {
    enabled = true
  }

  acl  = "private"
  tags = local.common-tags
}

resource "aws_s3_bucket_object" "parse-desc" {
  key    = "parse-desc.zip"
  bucket = aws_s3_bucket.resultbucket1.id
  source = "inventory/parse-desc.zip"
  tags   = local.common-tags
}

resource "aws_s3_bucket_object" "extract-queue" {
  key    = "extract-queue.zip"
  bucket = aws_s3_bucket.resultbucket1.id
  source = "inventory/extract-queue.zip"
  tags   = local.common-tags
}

resource "aws_s3_bucket_object" "validate" {
  key    = "validate.zip"
  bucket = aws_s3_bucket.resultbucket1.id
  source = "inventory/validate.zip"
  tags   = local.common-tags
}

resource "aws_s3_bucket_object" "successtest" {
  key    = "input/successtest.png"
  bucket = aws_s3_bucket.resultbucket.id
  source = "inventory/successtest.png"
  tags   = local.common-tags
  depends_on = [
    aws_lambda_event_source_mapping.queue
  ]
}

resource "aws_s3_bucket_public_access_block" "result1-block-public" {
  bucket                  = aws_s3_bucket.resultbucket1.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

output "s3bucket" {
  value       = aws_s3_bucket.resultbucket.arn
  description = "Bucket for input and Outputs"
}