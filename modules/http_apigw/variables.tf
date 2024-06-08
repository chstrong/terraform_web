variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "stage_name" {
  description = "Stage Name"
  type        = string
}

variable "cognito_client_id" {
  type = string
}

variable "cognito_userpool_endpoint" {
  type = string
}