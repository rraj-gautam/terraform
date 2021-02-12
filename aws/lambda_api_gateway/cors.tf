### CORS: handle all the OPTIONS requests using 'options-request-handler' lambda
data "terraform_remote_state" "account" {
  backend = "s3"

  config = {
    bucket = "api-gateway-tf-states"
    key    = "env:/${terraform.workspace}/account.tfstate"
    region = "us-east-1"
  }
}

### for ROOT
resource "aws_api_gateway_method" "root_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = var.enable_cache ? { 
    "method.request.header.origin" = false
    "method.request.header.Origin" = false
    #The boolean value indicates whether the parameter is required compulsory in request
  } : {}
}

resource "aws_api_gateway_integration" "root_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.root_options_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.terraform_remote_state.account.outputs.options_request_handler_lambda_invoke_arn

  cache_key_parameters = var.enable_cache ?   [ "method.request.header.origin", "method.request.header.Origin"] : []
}
//method settings for specific method (OPTIONS) to enable cache, since it is disabled by default
resource "aws_api_gateway_method_settings" "root_options_method_settings" {
  count         = var.enable_cache ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace
  method_path = "~1/${aws_api_gateway_method.root_options_method.http_method}" // ~1 is for path of root resource

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = true
    cache_ttl_in_seconds = "300"
    cache_data_encrypted = true
    require_authorization_for_cache_control = false
  }
}

//method settings for specific method (GET) to disable cache, since it is enabled by default
resource "aws_api_gateway_method_settings" "root_get_method_settings" {
  count         = var.enable_cache ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace
  method_path = "~1/GET"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = false
  }
}


### for PROXY
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = var.enable_cache ? { 
    "method.request.header.origin" = false
    "method.request.header.Origin" = false
  } : {}  
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.options_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.terraform_remote_state.account.outputs.options_request_handler_lambda_invoke_arn

  cache_key_parameters = var.enable_cache ?   [ "method.request.header.origin", "method.request.header.Origin" ] : []
}

resource "aws_api_gateway_method_settings" "proxy_options_method_settings" {
  count         = var.enable_cache ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace
  method_path = "${trimprefix(aws_api_gateway_resource.proxy_resource.path, "/")}/${aws_api_gateway_method.options_method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = true
    cache_ttl_in_seconds = "300"
    cache_data_encrypted = true
    require_authorization_for_cache_control = false
  }
}
resource "aws_api_gateway_method_settings" "proxy_get_method_settings" {
  count         = var.enable_cache ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = terraform.workspace
  method_path = "${trimprefix(aws_api_gateway_resource.proxy_resource.path, "/")}/GET"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = false
  }
}

resource "aws_iam_role_policy_attachment" "application_read" {
  role       = var.lambda_role_name
  policy_arn = data.terraform_remote_state.account.outputs.dynamodb_application_read_policy_arn
}