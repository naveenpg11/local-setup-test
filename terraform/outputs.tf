## Each output value exported by a module is be declared using an output block
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.dynamodb-table.arn
  description = "DynamoDB's ARN"
}

output "dynamodb_table_id" {
  value = aws_dynamodb_table.dynamodb-table.id
  description = "DynamoDB's ID"
}