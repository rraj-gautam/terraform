provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

    global_secondary_index {
      name               = "GameTitleIndex"
      hash_key           = "GameTitle"
      range_key          = "TopScore"
      write_capacity     = 10
      read_capacity      = 10
      projection_type    = "INCLUDE"
      non_key_attributes = ["UserId"]
    }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
    Confidentiality = terraform.workspace == "default" ? "Strictly Confidential" : "Business Only"
    "Impact Order" = terraform.workspace == "test" ? "Medium" : "High"
    "Availability" = terraform.workspace == "production" ? "High" : (terraform.workspace == "default" ? "Medium" : "Low")
    "Description" = "Cloud global settings (${terraform.workspace})"

  }

  point_in_time_recovery {
    enabled = true
  }
}
