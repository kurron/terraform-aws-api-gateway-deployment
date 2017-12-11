terraform {
    required_version = ">= 0.11"
    backend "s3" {}
}

provider "aws" {
    region     = "${var.region}"
}

resource "aws_api_gateway_integration" "parent_integration" {
    rest_api_id             = "${var.api_gateway_id}"
    resource_id             = "${var.parent_resource_id}"
    http_method             = "${var.parent_method_http_method}"
    integration_http_method = "ANY"
    type                    = "HTTP_PROXY"
    uri                     = "${var.target_url}"
    passthrough_behavior    = "WHEN_NO_MATCH"
    cache_key_parameters    = []
    request_parameters      = {
        "integration.request.header.x-forwarded-host" = "method.request.header.host"
        "integration.request.path.proxy"              = "method.request.path.proxy"
    }
}

resource "aws_api_gateway_integration" "child_integration" {
    rest_api_id             = "${var.api_gateway_id}"
    resource_id             = "${var.child_resource_id}"
    http_method             = "${var.child_method_http_method}"
    integration_http_method = "ANY"
    type                    = "HTTP_PROXY"
    uri                     = "${var.target_url}/{proxy}"
    passthrough_behavior    = "WHEN_NO_MATCH"
    cache_key_parameters    = ["method.request.path.proxy"]
    request_parameters      = {
        "integration.request.header.x-forwarded-host" = "method.request.header.host",
        "integration.request.path.proxy"              = "method.request.path.proxy"
    }
}

resource "aws_api_gateway_deployment" "deployment" {
    depends_on = ["aws_api_gateway_integration.parent_integration","aws_api_gateway_integration.child_integration"]

    rest_api_id       = "${var.api_gateway_id}"
    stage_name        = "${var.stage_name}"
    description       = "${var.deployment_description}"
    stage_description = "${var.stage_description}"
}

resource "aws_api_gateway_method_settings" "settings" {
    depends_on   = ["aws_api_gateway_deployment.deployment"]
    rest_api_id  = "${var.api_gateway_id}"
    stage_name   = "${var.stage_name}"
    method_path  = "*/*"
    settings {
        metrics_enabled        = "${var.metrics_enabled}"
        logging_level          = "${var.logging_level}"
        data_trace_enabled     = "${var.data_trace_enabled}"
        throttling_burst_limit = "${var.throttling_burst_limit}"
        throttling_rate_limit  = "${var.throttling_rate_limit}"
        caching_enabled        = "false"
    }
}
