resource "aws_vpc" "asmaa-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "asmaa-vpc"
  }
}

resource "aws_internet_gateway" "asmaa-gw" {
  vpc_id = aws_vpc.asmaa-vpc.id

  tags = {
    Name = "asmaa-gw"
  }
}



resource "aws_route_table" "asmaa-rtb" {
  vpc_id = aws_vpc.asmaa-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.asmaa-gw.id       #resource route (search)
  }

  tags = {
    Name = "asmaa-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
 subnet_id      = aws_subnet.asmaa-public-subnet.id
 route_table_id = aws_route_table.asmaa-rtb.id
}









