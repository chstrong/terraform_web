module "dynamodb" {
  source = "./modules/dynamodb"
  app_name = var.app_name
}

module "cognito" {
  source = "./modules/cognito"
  app_name = var.app_name
}

module "http_apigw" {
  source = "./modules/http_apigw"
  app_name = var.app_name
  stage_name = "dev"
}

module "hello_resource" {
  source = "./modules/hello_resource"
  app_name = var.app_name
  http_apigw_api_id = module.http_apigw.http_apigw_api_id
  http_apigw_lambda_execution_arn = module.http_apigw.http_apigw_lambda_execution_arn
}

#module "web_bucket" {
#  source  = "./modules/s3_cf_web_bucket"
#  web_bucket_name = "99thcloud-com-i349r0"
#  web_directory_to_upload = "./webdir"
#}