locals {
  retention_period = {
    test       = 30
    stage      = 60
    production = 90
  }

  tags = {
    owner = var.owner
    stack = var.stack
  }
}

resource "aws_api_gateway_rest_api" "default" {
  name = var.name

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  policy                   = var.gateway_policy
  minimum_compression_size = 5120 // Equivalent to 5kb
  tags                     = local.tags
}

# All incoming requests to API Gateway must match with a configured resource and method in order to be handled.
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = var.authorization
  authorizer_id = var.authorizer_id
  api_key_required = var.api_key_required
}

# Each method on an API gateway resource has an integration which specifies where incoming requests are routed.
resource "aws_api_gateway_integration" "lambda_integration_method" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_method.proxy_method.resource_id
  http_method = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Unfortunately the proxy resource cannot match an empty path at the root of the API.
# To handle that, a similar configuration must be applied to the root resource that is built in to the REST API object:
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "ANY"
  authorization = var.authorization
  authorizer_id = var.authorizer_id
  api_key_required = var.api_key_required
}

resource "aws_api_gateway_integration" "lambda_integration_root" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}


resource "aws_api_gateway_stage" "deployment_stage" {
  #count         = var.enable_cache ? 1 : 0
  stage_name    =  terraform.workspace
  rest_api_id   = aws_api_gateway_rest_api.default.id
  deployment_id = aws_api_gateway_deployment.lambda_gateway.id

  cache_cluster_enabled = var.enable_cache ? true : false
  cache_cluster_size =  0.5
}

# Finally, you need to create an API Gateway "deployment" in order to activate the configuration and expose the API at a URL that can be used for testing:
resource "aws_api_gateway_deployment" "lambda_gateway" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration_method,
    aws_api_gateway_integration.lambda_integration_root,
  ]

  lifecycle {
    create_before_destroy = true
  }

  rest_api_id = aws_api_gateway_rest_api.default.id

  #can add triggers to redeploy on any changes of key values.
  triggers = {
    redeployment = sha1(join(",",[md5(file("${path.module}/main.tf")),md5(file("${path.module}/cors.tf"))]))
  }

  #changes in api_gateway doesn’t deploy by default so I used the description value with md5 hash of the file so that re-deploy will occur when there is change in file
  #https://github.com/hashicorp/terraform/issues/6613  (look comment  @charlieegan3)
  stage_description = filemd5("main.tf")
}

# Allowing API Gateway to Access Lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  function_name = var.lambda_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
}

# send Access-Control-Allow-Origin = '*' for 401, 500, 502 errors
resource "aws_api_gateway_gateway_response" "lambda_gateway_response_for_401" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "method.request.header.Origin"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_gateway_response" "lambda_gateway_response_for_expired_token" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  response_type = "EXPIRED_TOKEN"
  status_code   = "401"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "method.request.header.Origin"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_gateway_response" "lambda_gateway_response_for_access_denied" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  response_type = "ACCESS_DENIED"
  status_code   = "401"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "method.request.header.Origin"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_gateway_response" "lambda_gateway_response_for_500" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "method.request.header.Origin"
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

# Attach the WAF to the gateway 
data "aws_region" "current" {
}

resource "aws_wafregional_web_acl_association" "waf" {
  count = var.endpoint_type == "PRIVATE" ? 0 : 1
  resource_arn = format(
    "arn:aws:apigateway:%s::/restapis/%s/stages/%s",
    data.aws_region.current.name,
    aws_api_gateway_rest_api.default.id,
    terraform.workspace,
  )
  web_acl_id = var.waf_id
}

resource "aws_api_gateway_method_settings" "cloudwatch_loging" {
  #if stage is not created explicitly than aws_api_gateway_deployment creates a stage, but need to set depends_on
  depends_on  = [aws_api_gateway_deployment.lambda_gateway]
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace

  #Method path */* for overriding all methods in the stage, mentioned in docs
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.default.id}/${terraform.workspace}"
  retention_in_days = local.retention_period[terraform.workspace]
  tags              = local.tags
}

resource "aws_cloudwatch_log_subscription_filter" "log_collector_lambda" {
  name           = "lambda_function_logfilter"
  log_group_name = aws_cloudwatch_log_group.log_group.name
  filter_pattern = "" #The filter pattern "" matches all log events.

  destination_arn = replace(var.datadog_lambda_arn, ":$LATEST", "")
  depends_on      = [aws_cloudwatch_log_group.log_group]
}
