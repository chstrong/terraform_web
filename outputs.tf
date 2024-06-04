output "cognito_user_pool_id" {
  value = module.cognito.cognito_user_pool_id
}

output "cognito_user_pool_client_id" {
  value = module.cognito.cognito_user_pool_client_id
}

output "dynamodb_todo_table_name" {
  value = module.dynamodb.dynamodb_todo_table
}