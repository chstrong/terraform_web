/*
resource "aws_lambda_function" "create_todo_lambda" {
  filename = "create_todo_lambda.zip" # Replace with your zip file
  function_name = var.lambda_todo_function_name
  handler = "handler.handler" # Replace with your handler function
  runtime = "nodejs20.x" # Replace with your runtime
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = module.dynamodb.todo_table_name
    }
  }
}
*/

# Lambda Function Source Code (Replace with your actual script)

data "archive_file" "hello_lambda" {
  type = "zip"
  source_file = "./lambda_code/hello/index.mjs"
  output_path = "./lambda_code/hello/hello_lambda.zip"
}

# Lambda Function with Zip File

resource "aws_lambda_function" "hello_lambda" {
  filename = data.archive_file.hello_lambda.output_path
  function_name = "hello_lambda"
  handler = "index.handler"
  runtime = "nodejs20.x"
  role = aws_iam_role.lambda_role.arn
  source_code_hash = "ur23092r0y83ru23jr3opr23ugfd9y"
}

resource "aws_apigatewayv2_integration" "create_hello_lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.hello_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}