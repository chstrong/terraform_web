module "dynamodb" {
  source = "./modules/dynamodb"
  todo_table_name = "${var.app_name}-todo-table"
}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name = "${var.app_name}_user_pool"
  user_pool_client_name = "${var.app_name}_user_pool_client"
}

module "lambda_backend" {
  source = "./modules/lambda_backend"
  app_name = var.app_name
  aws_region = var.aws_region
  cognito_client_id = module.cognito.cognito_user_pool_client_id
  cognito_userpool_endpoint = module.cognito.cognito_user_pool_endpoint
  dynamodb_todo_table_arn = module.dynamodb.dynamodb_todo_table_arn
}

#module "web_bucket" {
#  source  = "./modules/s3_cf_web_bucket"
#  web_bucket_name = "99thcloud-com-i349r0"
#  web_directory_to_upload = "./webdir"
#}