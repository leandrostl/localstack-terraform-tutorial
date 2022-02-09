# Output do projeto
output "api_id" {
  value = aws_api_gateway_rest_api.messages.id
}

output "resource_id" {
  value = aws_api_gateway_resource.messages.id
}

output "queue_url" {
  value = aws_sqs_queue.messages.url
}

output "base_url" {
  value = "${var.defaut_endpoint}/restapis/${aws_api_gateway_rest_api.messages.id}/${aws_api_gateway_deployment.messages.stage_name}/_user_request_/${aws_api_gateway_resource.messages.path_part}"
}
