terraform {
    required_version = ">= 0.10.7"
    backend "s3" {}
}

provider "aws" {
    region     = "${var.region}"
}

resource "aws_api_gateway_resource" "parent_resource" {
    rest_api_id = "${var.api_gateway_id}"
    parent_id   = "${var.api_gateway_root_resource_id}"
    path_part   = "${var.api_root_path}"
}

resource "aws_api_gateway_resource" "child_resource" {
    rest_api_id = "${var.api_gateway_id}"
    parent_id   = "${aws_api_gateway_resource.parent_resource.id}"
    path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "parent_method" {
    rest_api_id        = "${var.api_gateway_id}"
    resource_id        = "${aws_api_gateway_resource.parent_resource.id}"
    http_method        = "ANY"
    authorization      = "NONE"
    api_key_required   = "${var.api_key_required}"
    request_parameters = {
        "method.request.header.host" = true,
        "method.request.path.proxy"  = true
    }
}

resource "aws_api_gateway_method" "child_method" {
    rest_api_id        = "${var.api_gateway_id}"
    resource_id        = "${aws_api_gateway_resource.child_resource.id}"
    http_method        = "ANY"
    authorization      = "NONE"
    api_key_required   = "${var.api_key_required}"
    request_parameters = {
        "method.request.header.host" = true,
        "method.request.path.proxy"  = true
    }
}

resource "aws_api_gateway_integration" "parent_integration" {
    depends_on = ["aws_api_gateway_method.parent_method"]

    rest_api_id             = "${var.api_gateway_id}"
    resource_id             = "${aws_api_gateway_resource.parent_resource.id}"
    http_method             = "${aws_api_gateway_method.parent_method.http_method}"
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
    depends_on = ["aws_api_gateway_method.child_method"]

    rest_api_id             = "${var.api_gateway_id}"
    resource_id             = "${aws_api_gateway_resource.child_resource.id}"
    http_method             = "${aws_api_gateway_method.child_method.http_method}"
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
