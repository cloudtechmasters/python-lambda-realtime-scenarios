resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Archive a single file.

data "archive_file" "init" {
  type        = "zip"
  source_file = "ec2-stop.py"
  output_path = "ec2-stop.zip"
}

resource "aws_lambda_function" "vamsi_lamda" {
  filename      = "ec2-stop.zip"
  function_name = "ec2-stop"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "ec2-stop.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("ec2-stop.zip")

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
