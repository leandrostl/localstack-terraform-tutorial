provider "aws" {

  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway = var.defaut_endpoint
    cloudwatch = var.defaut_endpoint
    dynamodb   = var.defaut_endpoint
    iam        = var.defaut_endpoint
    lambda     = var.defaut_endpoint
    sqs        = var.defaut_endpoint
  }
}