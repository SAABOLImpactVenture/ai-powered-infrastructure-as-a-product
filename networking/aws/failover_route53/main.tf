terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "zone_id" { type = string }
variable "domain"  { type = string }
variable "primary_elb" { type = string }
variable "secondary_elb" { type = string }

resource "aws_route53_health_check" "primary" {
  fqdn              = var.domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/healthz"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "app" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  set_identifier = "primary"
  alias { name = var.primary_elb, zone_id = var.zone_id, evaluate_target_health = true }
  failover_routing_policy { type = "PRIMARY" }
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "app_failover" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  set_identifier = "secondary"
  alias { name = var.secondary_elb, zone_id = var.zone_id, evaluate_target_health = true }
  failover_routing_policy { type = "SECONDARY" }
}
