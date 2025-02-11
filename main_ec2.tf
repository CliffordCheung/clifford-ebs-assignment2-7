locals {
  resource_prefix = "clifford"
}


resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon2023.id #"ami-0df8c184d5f6ae949" #Challenge, find the AMI ID of Amazon Linux 2 in us-east-1
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  subnet_id                   = data.aws_subnet.existing_ce9_pub_subnet.id
  associate_public_ip_address = true
  key_name                    = "clifford_keypair_1218" #Change to your keyname, e.g. jazeel-key-pair
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  user_data = <<-EOL
 #!/bin/bash

 sleep 100
 sudo mkfs -t ext4 /dev/xvdb
 sudo mkdir /mydata
 sudo mount /dev/xvdb /mydata

 EOL


  tags = {
    Name = "${local.resource_prefix}-ebs-ec2" # Ensure your
  }
}


output "ec2_public_ip" {
  value = aws_instance.public.public_ip
}


resource "aws_security_group" "allow_ssh" {
  name        = "${local.resource_prefix}-security-group-ssh"
  description = "Allow SSH inbound"
  vpc_id      = data.aws_vpc.existing_ce9_vpc.id

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/* resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {

 count = length(var.sg_ingress_rules)   
 security_group_id = aws_security_group.allow_ssh.id
 cidr_ipv4         = "0.0.0.0/0" 
 from_port         = 22
 ip_protocol       = "tcp"
 to_port           = 22
} */