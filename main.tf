module "dynamodb" {
  source = "./modules/dynamodb"
  todo_table_name = "${var.app-name}-todo-table"
}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name = "${var.app-name}-user-pool"
  user_pool_client_name = "${var.app-name}-user-pool-client"
}

module "lambda_backend" {
  source = "./modules/lambda_backend"
  api_gateway_name = "todo_api"
  lambda_role_name = "todo_lambda_role"
  lambda_policy_name = "todo_lambda_policy"
  aws_region = "us-east-1"
  cognito_client_id = module.cognito.cognito_user_pool_client_id
  cognito_userpool_endpoint = module.cognito.cognito_user_pool_endpoint
  dynamodb_todo_table_arn = module.dynamodb.dynamodb_todo_table_arn
}

#module "web_bucket" {
#  source  = "./modules/s3_cf_web_bucket"
#  web_bucket_name = "99thcloud-com-i349r0"
#  web_directory_to_upload = "./webdir"
#}