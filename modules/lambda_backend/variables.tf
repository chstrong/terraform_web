variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "aws_region" {
  description = "The AWS Region"
  type        = string
}

variable "cognito_client_id" {
  description = "The cognito client id"
  type        = string
}

variable "cognito_userpool_endpoint" {
  description = "The cognito user pool endpoint"
  type        = string
}

variable "dynamodb_todo_table_arn" {
  description = "The todo table arn"
  type        = string
}

