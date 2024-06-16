variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "http_apigw_api_id" {
  description = "The HTTP API Gateway."
  type        = string
}

variable "http_apigw_lambda_execution_arn" {
  description = "The HTTP API Gateway Execution ARN."
  type        = string
}

variable "aws_region" {
  description = "The application region"
  type        = string
  default = "us-east-1"
}

variable "http_apigw_authorizer_id" {
  type = string
}