resource "aws_iam_role" "blogrole10" {
  name               = "iamrole-${random_id.rando.hex}"
  description        = "IAM Role"
  assume_role_policy = <<EOF
{
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "sts:AssumeRole"
                ],
                "Principal" : {
                    "Service" : [
                        "ec2.amazonaws.com",
                        "lambda.amazonaws.com",
                        "s3.amazonaws.com"
                    ]
                }
            }
        ]
    }
EOF
}

variable "policy-attach" {
  default = {
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"                       = 1,
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess"                      = 2,
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess"                      = 3,
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess"                     = 4,
    "arn:aws:iam::aws:policy/AmazonTextractFullAccess"                 = 5,
    "arn:aws:iam::aws:policy/ComprehendMedicalFullAccess"              = 6,
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"                     = 7,
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" = 8
  }
}

resource "aws_iam_role_policy_attachment" "blogrole10" {
  for_each   = var.policy-attach
  policy_arn = each.key
  role       = aws_iam_role.blogrole10.name
}