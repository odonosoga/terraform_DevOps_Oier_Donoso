variable "aws_access_key_id" {
  
}

variable "aws_secret_access_key" {
  
}

variable "aws_session_token" {
  
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  description = "key pair AWS"
  type        = string
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "adminzubiri"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}
