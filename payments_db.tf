resource "aws_dynamodb_table" "payment_table" {
  name           = "order_payment"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "order_id"
  attribute {
    name = "order_id"
    type = "N"
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.payment_table.name
}