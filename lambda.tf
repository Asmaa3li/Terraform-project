resource "aws_iam_role" "lambda_role" {
name   = "Lambda_Function_Role"
assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}


resource "aws_iam_policy" "iam_policy_for_lambda" {
 name         = "iam_policy_for_lambda_role_ses"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::asmaa-terraform-bucket-src-bucket",
                "arn:aws:s3:::asmaa-terraform-bucket-src-bucket/*"
            ]
        }
    ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}



data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.9"
  depends_on = [ aws_iam_role_policy_attachment.attach_s3_policy ]

  # source_code_hash = data.archive_file.lambda.output_base64sha256

}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "asmaa-terraform-bucket"

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::asmaa-terraform-bucket"
}
