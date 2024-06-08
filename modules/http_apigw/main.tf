# HTTP API
resource "aws_apigatewayv2_api" "api" {
  name          = "${var.app_name}_api"
  protocol_type = "HTTP"
}

resource "aws_cloudwatch_log_group" "api_gateway_logs_hello" {
  name              = "/aws/apigateway/api"
  log_group_class   = "STANDARD"
  retention_in_days = 1
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs_hello.arn
    format = jsonencode({
      authorizerError           = "$context.authorizer.error",
      identitySourceIP          = "$context.identity.sourceIp",
      integrationError          = "$context.integration.error",
      integrationErrorMessage   = "$context.integration.errorMessage"
      integrationLatency        = "$context.integration.latency",
      integrationRequestId      = "$context.integration.requestId",
      integrationStatus         = "$context.integration.integrationStatus",
      integrationStatusCode     = "$context.integration.status",
      requestErrorMessage       = "$context.error.message",
      requestErrorMessageString = "$context.error.messageString",
      requestId                 = "$context.requestId",
      routeKey                  = "$context.routeKey",
    })
  }
}

resource "aws_apigatewayv2_authorizer" "auth" {
  api_id           = aws_apigatewayv2_api.api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.app_name}_authorizer"

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = "https://${var.cognito_userpool_endpoint}"
  }
}
