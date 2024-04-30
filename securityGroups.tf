resource "aws_security_group" "asmaa-secgroup" {
  name        = "asmaa-secgroup"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.asmaa-vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asmaa-secgroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.asmaa-secgroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# ================================================== Second Security Group ==================================================

resource "aws_security_group" "asmaa-secgroup2" {
  name        = "asmaa-secgroup2"
  description = "Allow SSH and port 3000 traffic from VPC CIDR"
  vpc_id      = aws_vpc.asmaa-vpc.id

  ingress {
    from_port   = 22  # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.asmaa-vpc.cidr_block]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.asmaa-vpc.cidr_block]
  }

  tags = {
    Name = "asmaa-secgroup2"
  }
}