resource "aws_lambda_function" "upload" {
  filename         = "inventory/upload.zip"
  function_name    = "inventory-${random_id.rando.hex}"
  role             = aws_iam_role.blogrole10.arn
  handler          = "index.lambda_handler"
  source_code_hash = filebase64sha256("inventory/upload.zip")

  runtime     = "python3.7"
  timeout     = 180
  description = "Upload"
}

resource "aws_lambda_function" "validate" {
  s3_bucket = aws_s3_bucket.resultbucket1.id
  s3_key = "validate.zip"
  function_name    = "validate-${random_id.rando.hex}"
  role             = aws_iam_role.blogrole10.arn
  handler          = "blog-validate.lambda_handler"

  runtime     = "python3.7"
  timeout     = 120
  description = "validate lambda function"
  environment {
    variables = {
        invalidqueue = "${aws_sqs_queue.INVALIDATEQUEUE.arn}"
        resultbucket = "${aws_s3_bucket.resultbucket.id}"
        invalidsns = "${aws_sns_topic.snstopic.arn}"
    }
  }
}

resource "aws_lambda_function" "parse" {
  s3_bucket = aws_s3_bucket.resultbucket1.id
  s3_key = "parse-desc.zip"
  function_name    = "parse-${random_id.rando.hex}"
  role             = aws_iam_role.blogrole10.arn
  handler          = "blog-parse.lambda_handler"

  runtime     = "python3.7"
  timeout     = 120
  description = "parse lambda function"
}

resource "aws_lambda_function" "extract" {
  s3_bucket = aws_s3_bucket.resultbucket1.id
  s3_key = "extract-queue.zip"
  function_name    = "extract-${random_id.rando.hex}"
  role             = aws_iam_role.blogrole10.arn
  handler          = "blog-extract.lambda_handler"

  runtime     = "python3.7"
  timeout     = 120
  description = "extract lambda function"

  environment {
    variables = {
        allqueue = "${aws_sqs_queue.VALIDATEQUEUE.arn}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "queue" {
  batch_size = 10
  enabled = true
  event_source_arn = aws_sqs_queue.ALLEQUEUE.arn
  function_name = aws_lambda_function.validate.arn
}

resource "aws_lambda_permission" "bucketpermission" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.parse.arn
  principal = "s3.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn = aws_s3_bucket.resultbucket.arn
}

output "LambdaFunctionExtract" {
  value = aws_lambda_function.extract.arn
  description = "Lambda Function to extract key-value from form"
}

output "LambdaFunctionValidate" {
  value = aws_lambda_function.validate.arn
  description = "Lambda Function to validate form"
}

output "LambdaFunctionComprehendMedical" {
  value = aws_lambda_function.parse.arn
  description = "Lambda Function to detect medical entities using comprehend medical"
}