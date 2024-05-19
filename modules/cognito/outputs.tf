output "cognito_user_pool_id" {
    value = aws_cognito_user_pool.main_user_pool.id
}

output "cognito_user_pool_client_id" {
    value = aws_cognito_user_pool_client.main_user_pool_client.id
}

output "cognito_user_pool_name" {
    value = aws_cognito_user_pool.main_user_pool.name
}

output "cognito_user_pool_arn" {
    value = aws_cognito_user_pool.main_user_pool.arn
}

output "cognito_user_pool_endpoint" {
    value = aws_cognito_user_pool.main_user_pool.endpoint
}