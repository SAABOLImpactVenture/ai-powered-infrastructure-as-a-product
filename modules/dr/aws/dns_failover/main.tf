terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type=string }
variable "zone_id" { type=string }
variable "domain" { type=string }
variable "primary_dns_name" { type=string }
variable "primary_zone_id" { type=string }
variable "secondary_dns_name" { type=string }
variable "secondary_zone_id" { type=string }

resource "aws_route53_health_check" "primary" {
  fqdn          = var.domain
  port          = 443
  type          = "HTTPS"
  resource_path = "/healthz"
}

resource "aws_route53_record" "primary" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  set_identifier = "primary"
  alias { name = var.primary_dns_name, zone_id = var.primary_zone_id, evaluate_target_health = true }
  failover_routing_policy { type = "PRIMARY" }
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "secondary" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  set_identifier = "secondary"
  alias { name = var.secondary_dns_name, zone_id = var.secondary_zone_id, evaluate_target_health = true }
  failover_routing_policy { type = "SECONDARY" }
}
