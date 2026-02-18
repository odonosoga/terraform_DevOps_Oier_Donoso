resource "aws_vpc" "main" {
    cidr_block = "10.16.0.0/16"
    enable_dns_support = true
    
    tags = {
      name = "Lehenengo VPC"
    }
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.16.100.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    name = "Subnet 1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.16.101.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  

  tags = {
    name = "Subnet 2"
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow HTTP, SSH and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_route_table" "routetable1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    name = "Route Table 1"
  }
}

resource "aws_route_table_association" "asoc1" {
  route_table_id = aws_route_table.routetable1.id
  subnet_id      = aws_subnet.subnet1.id
}
resource "aws_route_table_association" "asoc2" {
  route_table_id = aws_route_table.routetable1.id
  subnet_id      = aws_subnet.subnet2.id
}