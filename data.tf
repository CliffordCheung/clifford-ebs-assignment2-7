
data "aws_vpc" "existing_ce9_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


data "aws_subnet" "existing_ce9_pub_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

data "aws_ami" "amazon2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami*"]
  }
}