resource "aws_cognito_user_pool" "main_user_pool" {
  name = var.user_pool_name

  email_verification_subject = "Your Verification Code"
  email_verification_message = "Please use the following code: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 3
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "main_user_pool_client" {
  name                = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.main_user_pool.id
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  generate_secret     = true

  supported_identity_providers = ["COGNITO"] # "COGNITO", "Facebook", "SignInWithApple", "Google", "LoginWithAmazon"

  callback_urls        = ["https://example.com/"]
  default_redirect_uri = "https://example.com/" # URL must be one of the URL in callback_urls
  logout_urls          = ["https://example.com/logout"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"] # "code", "implicit", "client_credentials"]
  allowed_oauth_scopes                 = ["email", "profile", "openid"] # "phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"
}

resource "aws_cognito_user_pool_domain" "main_user_pool_domain" {
  domain       = "uu39ru902r38yru9"
  user_pool_id = aws_cognito_user_pool.main_user_pool.id
}
