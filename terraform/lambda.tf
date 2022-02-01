# Lambdas para processar as mensagens
data "archive_file" "message_receiver" {
  type        = "zip"
  output_path = "../message_receiver.zip"
  source_dir  = "../lambdas/message-receiver/"
}

resource "aws_lambda_function" "message_receiver" {
  function_name    = "message_receiver"
  filename         = data.archive_file.message_receiver.output_path
  source_code_hash = data.archive_file.message_receiver.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  role             = "fake_role"
}
