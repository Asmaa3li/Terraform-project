resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "asmaa-private-subnet1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"  
}

resource "aws_subnet" "asmaa-private-subnet2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-1a"  
}



resource "aws_elasticache_subnet_group" "example_subnet_group" {
  name       = "example-subnet-group"
  subnet_ids = [aws_subnet.asmaa-private-subnet1.id , aws_subnet.asmaa-private-subnet2.id]
}

resource "aws_elasticache_parameter_group" "example_parameter_group" {
  name        = "example-parameter-group"
  family      = "redis7"  
  description = "Example parameter group for ElastiCache"
}

resource "aws_elasticache_cluster" "example_cluster" {
  cluster_id           = "example-cluster"
  engine               = "redis"  
  node_type            = "cache.t2.micro"  
  num_cache_nodes      = 1  
  subnet_group_name    = aws_elasticache_subnet_group.example_subnet_group.name
  parameter_group_name = aws_elasticache_parameter_group.example_parameter_group.name

  security_group_ids = [
    aws_security_group.example_security_group.id
  ]

}

resource "aws_security_group" "example_security_group" {
  name        = "example-security-group"
  description = "Security group for ElastiCache cluster"

  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 6379  
    to_port     = 6379
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
