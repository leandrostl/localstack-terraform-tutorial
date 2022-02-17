resource "aws_dynamodb_table" "quotes" {
    name = "Quotes"
    hash_key = "author"
    range_key = "quote"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "author"
      type = "S"
    }
    attribute {
      name = "quote"
      type = "S"
    }
}