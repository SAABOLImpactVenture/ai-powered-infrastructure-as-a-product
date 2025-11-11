resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = True
  enable_dns_hostnames = True
  tags = merge(var.tags, { Name = "iaap-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "iaap-igw" })
}

resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "iaap-public-${replace(each.key, "/", "-")}" })
}
