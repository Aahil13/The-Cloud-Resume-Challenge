resource "aws_dynamodb_table_item" "counter_table_item" {
  table_name = aws_dynamodb_table.counter_table.name
  hash_key   = aws_dynamodb_table.counter_table.hash_key

  item = <<ITEM
{
  "CounterID": {"S": "1"},
  "VisitorCount": {"N": "0"}
}
ITEM

}

resource "aws_dynamodb_table" "counter_table" {
  name           = "visitor_count"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "CounterID"

  attribute {
    name = "CounterID"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "visitor_counter_table"
    Environment = "production"
  }
}
