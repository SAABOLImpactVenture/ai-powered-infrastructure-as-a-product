variable "region" { type=string, default="us-east-1" }
variable "vpc_cidr" { type=string, default="10.80.0.0/16" }
variable "public_subnet_cidrs" { type=list(string), default=["10.80.1.0/24","10.80.2.0/24"] }
variable "tags" { type=map(string), default={ owner="platform-team", env="dev", cost-center="platform" } }
