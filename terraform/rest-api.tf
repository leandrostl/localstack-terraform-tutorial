# Declarando nossa api para acesso de mensagens e os métodos
resource "aws_api_gateway_rest_api" "messages" {
  name        = "Messages"
  description = "Api para consumo e envio de mensagens para a aplicação."
}

resource "aws_api_gateway_resource" "messages" {
  rest_api_id = aws_api_gateway_rest_api.messages.id
  parent_id   = aws_api_gateway_rest_api.messages.root_resource_id
  path_part   = "messages"
}

resource "aws_api_gateway_method" "get_messages" {
  rest_api_id   = aws_api_gateway_rest_api.messages.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_message" {
  rest_api_id   = aws_api_gateway_rest_api.messages.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "message_receiver" {
  rest_api_id             = aws_api_gateway_rest_api.messages.id
  resource_id             = aws_api_gateway_resource.messages.id
  http_method             = aws_api_gateway_method.post_message.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.message_receiver.invoke_arn
}

resource "aws_api_gateway_deployment" "messages" {
  depends_on = [
    aws_api_gateway_integration.message_receiver,
  ]

  rest_api_id = aws_api_gateway_rest_api.messages.id
  stage_name  = "dev"
}
