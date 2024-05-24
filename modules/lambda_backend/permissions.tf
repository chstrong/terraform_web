# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}_lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Lambda Function
resource "aws_iam_policy" "lambda_policy" {
  name = "${var.app_name}_lambda_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:PutItem",
      ],
      "Resource" : [
        var.dynamodb_todo_table_arn,
      ],
    }]
  })
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
