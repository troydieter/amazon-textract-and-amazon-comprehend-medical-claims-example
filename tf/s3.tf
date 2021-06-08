resource "aws_s3_bucket" "resultbucket" {
  bucket = "result-${random_id.rando.hex}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }

  }

  versioning {
    enabled = true
  }

  acl = "private"
  tags = local.common-tags
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
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }

  }

  versioning {
    enabled = true
  }

  acl = "private"
  tags = local.common-tags
}

resource "aws_s3_bucket_object" "parse-desc" {
  key                    = "parse-desc.zip"
  bucket                 = aws_s3_bucket.resultbucket1.id
  source                 = "inventory/parse-desc.zip"
  server_side_encryption = "AES256"
  tags = local.common-tags
}

resource "aws_s3_bucket_object" "extract-queue" {
  key                    = "extract-queue.zip"
  bucket                 = aws_s3_bucket.resultbucket1.id
  source                 = "inventory/extract-queue.zip"
  server_side_encryption = "AES256"
  tags = local.common-tags
}

resource "aws_s3_bucket_object" "validate" {
  key                    = "validate.zip"
  bucket                 = aws_s3_bucket.resultbucket1.id
  source                 = "inventory/validate.zip"
  server_side_encryption = "AES256"
  tags = local.common-tags
}

resource "aws_s3_bucket_public_access_block" "result1-block-public" {
  bucket                  = aws_s3_bucket.resultbucket1.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

output "s3bucket" {
  value = aws_s3_bucket.resultbucket.arn
  description = "Bucket for input and Outputs"
}