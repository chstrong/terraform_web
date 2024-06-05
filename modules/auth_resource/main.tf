resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}_auth_resource_lambda_role"

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
  function_name = aws_lambda_function.auth_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.http_apigw_lambda_execution_arn}/*/*"
}

data "archive_file" "auth_lambda" {
  type = "zip"
  source_file = "./lambda_code/auth/index.mjs"
  output_path = "./lambda_code/auth/auth_lambda.zip"
}

# Lambda Function with Zip File
resource "aws_lambda_function" "auth_lambda" {
  filename = data.archive_file.auth_lambda.output_path
  function_name = "${var.app_name}_auth_lambda"
  handler = "index.handler"
  runtime = "nodejs20.x"
  role = aws_iam_role.lambda_role.arn
  source_code_hash = "ur23092r0y83ru23jr3opr23ugfd9y"
}

resource "aws_apigatewayv2_integration" "auth_lambda_integration" {
  api_id           = var.http_apigw_api_id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"

  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.auth_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "auth_lambda_route" {  
  api_id             = var.http_apigw_api_id
  route_key          = "GET /auth"
  target             = "integrations/${aws_apigatewayv2_integration.auth_lambda_integration.id}"
}