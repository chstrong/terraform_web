/*
resource "aws_lambda_function" "create_todo_lambda" {
  filename = "create_todo_lambda.zip" # Replace with your zip file
  function_name = var.lambda_todo_function_name
  handler = "handler.handler" # Replace with your handler function
  runtime = "nodejs20.x" # Replace with your runtime
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DYNAMOtodo_add_TABLE_NAME = module.dynamodb.todo_table_name
    }
  }
}
*/

# https://ksarath.medium.com/provisioning-aws-api-gateway-using-terraform-95f64b492397
# https://www.youtube.com/watch?v=7u1p5dieIh8

# Lambda Function Source Code (Replace with your actual script)

resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}_todo_add_lambda_role"

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
  function_name = aws_lambda_function.todo_add_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.http_apigw_lambda_execution_arn}/*/*"
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = [
      "dynamodb:PutItem",
    ]
    resources = [
      var.todo_table_arn
    ]
  }
}

resource "aws_iam_policy" "dynamodb_lambda_policy" {
  name        = "dynamodb-lambda-policy"
  description = "This policy will be used by the lambda to write get data from DynamoDB"
  policy      = data.aws_iam_policy_document.lambda_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_attachements" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_lambda_policy.arn
}

data "archive_file" "todo_add_lambda" {
  type = "zip"
  source_file = "./lambda_code/todo/add/todo_add.py"
  output_path = "./lambda_code/todo/add/todo_add_lambda.zip"
}

# Lambda Function with Zip File
resource "aws_lambda_function" "todo_add_lambda" {
  filename = data.archive_file.todo_add_lambda.output_path
  function_name = "${var.app_name}_todo_add_lambda"
  handler = "todo_add.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.lambda_role.arn
  source_code_hash = "ur23092r0y83ru23jr3opr2ugfd9y"

    environment {
    variables = {
      TABLE_NAME = var.todo_table
    }
  }
}

resource "aws_apigatewayv2_integration" "todo_add_lambda_integration" {
  api_id           = var.http_apigw_api_id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"

  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.todo_add_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "todo_add_lambda_route" {  
  api_id             = var.http_apigw_api_id
  route_key          = "POST /todo/add"
  target             = "integrations/${aws_apigatewayv2_integration.todo_add_lambda_integration.id}"
}