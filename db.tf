resource "aws_security_group" "rds" {
  name        = "rds-sg"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name = "rsdsubnet"
  description = "subnetDb"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_db_parameter_group" "rds-parameter" {
  name = "rds-mysql"
  family = "mysql5.7"
  description = "Parameter group for RDS MySQL 8.0"
  
  parameter {
    name = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "mi-db" {
  allocated_storage = 10
  db_name = "mymysql"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  final_snapshot_identifier = "mi-db-final-snapshot"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.name
  parameter_group_name = aws_db_parameter_group.rds-parameter.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  availability_zone = aws_subnet.subnet1.availability_zone
}