resource "aws_subnet" "asmaa-public-subnet" {
  vpc_id     = aws_vpc.asmaa-vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "asmaa-public-subnet"
  }
}

# ================================================== Private Subnet ==================================================


resource "aws_subnet" "asmaa-private-subnet" {
  vpc_id     = aws_vpc.asmaa-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "asmaa-private-subnet"
  }
}