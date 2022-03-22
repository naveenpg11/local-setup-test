## Main Terraform module to create Dynamo DB

resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.partition_key_name

  attribute {
    name = var.partition_key_name
    type = var.partition_key_type_mapping[var.partition_key_type]
  }

  tags = {
    Name        = var.dynamodb_table_name
    Environment = "dev"
  }
}
