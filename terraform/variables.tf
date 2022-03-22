variable "dynamodb_table_name" {
    type = string
    description = "Name of the table to create in DynamoDB"
}

variable "read_capacity" {
  description = "read_capacity"
}
variable "write_capacity" {
  description = "write capacity"
}

variable "partition_key_type" {
    type = string
    description = "Partition Key Type"
    validation {
    condition     = contains(["string", "int", "binary"], var.partition_key_type)
    error_message = "Valid values for partition_key_type are (string, int, binary)."
  } 
}
variable "partition_key_name" {
    type = string
    description = "Partition Key name"
}

variable "partition_key_type_mapping" {
  description = "mapping for AWS Dynaom"
  default = {
    "string" = "S",
    "number" = "N",
    "binary" = "B"
  }
}