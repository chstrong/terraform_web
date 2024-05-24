# DynamoDB Table for Todos
resource "aws_dynamodb_table" "todo_table" {
  name         = "${var.app_name}_todo_table"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}