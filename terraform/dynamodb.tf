resource "aws_dynamodb_table" "quotes" {
    name = "Quotes"
    hash_key = "Author"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "Author"
      type = "S"
    }
}