output "dynamodb_todo_table" {
    value = aws_dynamodb_table.todo_table.name
}

output "dynamodb_todo_table_arn" {
    value = aws_dynamodb_table.todo_table.arn
}