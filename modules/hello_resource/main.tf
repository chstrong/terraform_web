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

# https://ksarath.medium.com/provisioning-aws-api-gateway-using-terraform-95f64b492397
# https://www.youtube.com/watch?v=7u1p5dieIh8

# Lambda Function Source Code (Replace with your actual script)

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

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.http_apigw_lambda_execution_arn}/*/*"
}

data "archive_file" "hello_lambda" {
  type = "zip"
  source_file = "./lambda_code/hello/index.mjs"
  output_path = "./lambda_code/hello/hello_lambda.zip"
}

# Lambda Function with Zip File
resource "aws_lambda_function" "hello_lambda" {
  filename = data.archive_file.hello_lambda.output_path
  function_name = "${var.app_name}_hello_lambda"
  handler = "index.handler"
  runtime = "nodejs20.x"
  role = aws_iam_role.lambda_role.arn
  source_code_hash = "ur23092r0y83ru23jr3opr23ugfd9y"
}

resource "aws_apigatewayv2_integration" "hello_lambda_integration" {
  api_id           = var.http_apigw_api_id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"

  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.hello_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "hello_lambda_route" {  
  api_id             = var.http_apigw_api_id
  route_key          = "GET /hello"
  target             = "integrations/${aws_apigatewayv2_integration.hello_lambda_integration.id}"
}