terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.vpc_region]
    }
  }
}

data "aws_region" "current" {
  provider = aws.vpc_region
}

resource "aws_vpc" "main" {
  provider   = aws.vpc_region
  cidr_block = lookup(var.cidr_block, data.aws_region.current.name)
  
}

resource "aws_internet_gateway" "vpc_gateway" {
  provider = aws.vpc_region
  vpc_id   = aws_vpc.main.id
}

resource "aws_route_table" "main_routetable" {
  provider = aws.vpc_region
  vpc_id   = aws_vpc.main.id
}

resource "aws_main_route_table_association" "route_table_association" {
  provider = aws.vpc_region

  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.main_routetable.id
}

resource "aws_subnet" "public_subnet" {
  count      = length(lookup(var.public_subnets, data.aws_region.current.name))
  provider   = aws.vpc_region
  vpc_id     = aws_vpc.main.id
  cidr_block = lookup(var.public_subnets, data.aws_region.current.name)[count.index]
}

resource "aws_route_table" "public_route_table" {
  vpc_id   = aws_vpc.main.id
  provider = aws.vpc_region
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gateway.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(lookup(var.public_subnets, data.aws_region.current.name))
  provider       = aws.vpc_region
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count      = length(lookup(var.private_subnets, data.aws_region.current.name))
  provider   = aws.vpc_region
  vpc_id     = aws_vpc.main.id
  cidr_block = lookup(var.private_subnets, data.aws_region.current.name)[count.index]
}

resource "aws_eip" "eip_nat_gateway" {
  provider         = aws.vpc_region
  vpc              = true
  public_ipv4_pool = "amazon"
}

resource "aws_nat_gateway" "nat_gateway" {
  provider      = aws.vpc_region
  allocation_id = aws_eip.eip_nat_gateway.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags          = merge(tomap({ "Name" : "decode-platform-nat-gw" }), tomap({ "STAGE" : var.STAGE }), var.DEFAULT_TAGS)
  depends_on    = [aws_internet_gateway.vpc_gateway, aws_eip.eip_nat_gateway]
}

resource "aws_route_table" "private_route_table" {
  vpc_id   = aws_vpc.main.id
  provider = aws.vpc_region
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(lookup(var.private_subnets, data.aws_region.current.name))
  provider       = aws.vpc_region
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

