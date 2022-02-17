# Lambdas para processar as frases
data "archive_file" "quote_receiver" {
  type        = "zip"
  output_path = "../lambdas/dist/quote_receiver.zip"
  source_dir  = "../lambdas/quote-receiver/"
}

resource "aws_lambda_function" "quote_receiver" {
  function_name    = "quote_receiver"
  filename         = data.archive_file.quote_receiver.output_path
  source_code_hash = data.archive_file.quote_receiver.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
  environment {
    variables = {
      SQS_URL = "${resource.aws_sqs_queue.quotes.url}"
    }
  }
}

data "archive_file" "quote_recover" {
  type        = "zip"
  output_path = "../lambdas/dist/quote_recover.zip"
  source_dir  = "../lambdas/quote-recover/"
}

resource "aws_lambda_function" "quote_recover" {
  function_name    = "quote_recover"
  filename         = data.archive_file.quote_recover.output_path
  source_code_hash = data.archive_file.quote_recover.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
}

data "archive_file" "quote_persister" {
  type        = "zip"
  output_path = "../lambdas/dist/quote_persister.zip"
  source_dir  = "../lambdas/quote-persister/"
}

resource "aws_lambda_function" "quote_persister" {
  function_name    = "quote_persister"
  filename         = data.archive_file.quote_persister.output_path
  source_code_hash = data.archive_file.quote_persister.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
}

resource "aws_lambda_event_source_mapping" "quotes" {
  event_source_arn = aws_sqs_queue.quotes.arn
  function_name    = aws_lambda_function.quote_persister.arn
}
