output "lambda_arn" {
  value = aws_lambda_function.hello_lambda.arn
  description = "ARN of the hello Lambda function"
}