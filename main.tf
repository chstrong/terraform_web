module "dynamodb" {
  source   = "./modules/dynamodb"
  app_name = var.app_name
}

module "cognito" {
  source   = "./modules/cognito"
  app_name = var.app_name
}

module "http_apigw" {
  source                    = "./modules/http_apigw"
  app_name                  = var.app_name
  stage_name                = "dev"
  cognito_client_id         = module.cognito.cognito_user_pool_client_id
  cognito_userpool_endpoint = module.cognito.cognito_user_pool_endpoint
}

module "hello_resource" {
  source                          = "./modules/resources/hello/index"
  app_name                        = var.app_name
  http_apigw_api_id               = module.http_apigw.http_apigw_api_id
  http_apigw_lambda_execution_arn = module.http_apigw.http_apigw_lambda_execution_arn
}

module "auth_resource" {
  source                          = "./modules/resources/auth/index"
  app_name                        = var.app_name
  http_apigw_api_id               = module.http_apigw.http_apigw_api_id
  http_apigw_lambda_execution_arn = module.http_apigw.http_apigw_lambda_execution_arn
  http_apigw_authorizer_id        = module.http_apigw.http_apigw_authorizer_id
}

module "todo_add_resource" {
  source                          = "./modules/resources/todo/add"
  app_name                        = var.app_name
  todo_table                      = module.dynamodb.dynamodb_todo_table
  todo_table_arn                  = module.dynamodb.dynamodb_todo_table_arn
  http_apigw_api_id               = module.http_apigw.http_apigw_api_id
  http_apigw_lambda_execution_arn = module.http_apigw.http_apigw_lambda_execution_arn
}

#module "web_bucket" {
#  source  = "./modules/s3_cf_web_bucket"
#  web_bucket_name = "99thcloud-com-i349r0"
#  web_directory_to_upload = "./webdir"
#}
