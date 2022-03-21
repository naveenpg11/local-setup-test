variable "dynamodb_table_name" {
    type = string
    description = "Name of the table to create in DynamoDB"
    default = "Orders"
}

variable "read_capacity" {
  description = "read_capacity"
  default = 5
}
variable "write_capacity" {
  description = "write capacity"
  default = 7
}

