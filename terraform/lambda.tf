# Lambdas para processar as mensagens
data "archive_file" "message_receiver" {
  type        = "zip"
  output_path = "../lambdas/dist/message_receiver.zip"
  source_dir  = "../lambdas/message-receiver/"
}

resource "aws_lambda_function" "message_receiver" {
  function_name    = "message_receiver"
  filename         = data.archive_file.message_receiver.output_path
  source_code_hash = data.archive_file.message_receiver.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
  environment {
    variables = {
      SQS_URL = "${resource.aws_sqs_queue.messages.url}"
    }
  }
}

data "archive_file" "message_processor" {
  type        = "zip"
  output_path = "../lambdas/dist/message_processor.zip"
  source_dir  = "../lambdas/message-processor/"
}

resource "aws_lambda_function" "message_processor" {
  function_name    = "message_processor"
  filename         = data.archive_file.message_processor.output_path
  source_code_hash = data.archive_file.message_processor.output_base64sha256
  handler          = "ProcessSQSRecords.lambda_handler"
  runtime          = "python3.8"
  role             = "fake_role"
}

resource "aws_lambda_event_source_mapping" "messages" {
  event_source_arn = aws_sqs_queue.messages.arn
  function_name    = aws_lambda_function.message_processor.arn
}
