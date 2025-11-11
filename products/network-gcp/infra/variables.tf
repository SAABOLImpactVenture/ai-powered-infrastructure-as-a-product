variable "project" { type=string }
variable "region" { type=string, default="us-central1" }
variable "network_name" { type=string, default="iaap-network" }
variable "subnet_cidr" { type=string, default="10.90.1.0/24" }
