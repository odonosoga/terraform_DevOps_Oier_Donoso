data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data                   = file("user_data.sh")
  subnet_id                   = aws_subnet.subnet1.id
  associate_public_ip_address = true  # ← AGREGAR

  tags = { Name = "Wordpress EC2 Instance" }
}

