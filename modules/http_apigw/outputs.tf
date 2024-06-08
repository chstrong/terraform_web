output "http_apigw_api_id" {
    value = aws_apigatewayv2_api.api.id
}

output "http_apigw_lambda_execution_arn" {
    value = aws_apigatewayv2_api.api.execution_arn
}

output "http_apigw_authorizer_id" {
    value = aws_apigatewayv2_authorizer.auth.id
}