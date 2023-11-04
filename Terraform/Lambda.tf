data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda_function.py"
  output_path = "${path.module}/../lambda_function.zip"
}

resource "aws_lambda_function" "resume_counter" {

  filename = "${path.module}/../lambda_function.zip"

  function_name = "resume_counter"
  handler       = "lambda_function.lambda_handler"

  role = aws_iam_role.lambda_exec.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"
}

resource "aws_cloudwatch_log_group" "resume_counter" {
  name = "/aws/lambda/${aws_lambda_function.resume_counter.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })

  inline_policy {
    name   = "dynamodb-update-policy"
    policy = aws_iam_policy.dynamodb_update_policy.policy
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_policy" "dynamodb_update_policy" {
  name        = "DynamoDBUpdatePolicy"
  description = "IAM policy for DynamoDB update permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["dynamodb:UpdateItem"],
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:us-east-1:313382416572:table/visitor_count"
      }
    ]
  })
}

