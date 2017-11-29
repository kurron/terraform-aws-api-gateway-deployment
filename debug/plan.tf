terraform {
    required_version = ">= 0.10.7"
    backend "s3" {}
}

data "terraform_remote_state" "api_gateway" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/aplication-services/api-gateway/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "api_gateway_binding" {
    backend = "s3"
    config {
        bucket = "transparent-test-terraform-state"
        key    = "us-west-2/debug/aplication-services/api-gateway-binding/terraform.tfstate"
        region = "us-east-1"
    }
}

module "api_gateway_deployment" {
    source = "../"

    region                    = "us-west-2"
    api_gateway_id            = "${data.terraform_remote_state.api_gateway.api_gateway_id}"
    parent_resource_id        = "${data.terraform_remote_state.api_gateway_binding.parent_resource_id}"
    parent_method_http_method = "${data.terraform_remote_state.api_gateway_binding.parent_method_http_method}"
    target_url                = "http://httpbin.org"
    child_resource_id         = "${data.terraform_remote_state.api_gateway_binding.child_resource_id}"
    child_method_http_method  = "${data.terraform_remote_state.api_gateway_binding.child_method_http_method}"
    stage_name                = "development"
    stage_description         = "APIs still under development"
    deployment_description    = "Initial cut of the API"
    metrics_enabled           = "true"
    logging_level             = "INFO"
    data_trace_enabled        = "true"
    throttling_burst_limit    = "300"
    throttling_rate_limit     = "30"
}

output "deployment_stage_name" {
    value = "${module.api_gateway_deployment.deployment_stage_name}"
}
