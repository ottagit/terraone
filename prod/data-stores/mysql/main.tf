provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "prod" {
  identifier_prefix = "prod-db"
  engine = "mysql"
  allocated_storage = 20
  instance_class = "db.m6i.large"
  skip_final_snapshot = true
  db_name = "proddb"

  # Set prod DB username and password
  username = var.prod_db_username
  password = var.prod_db_password
}

terraform {
  backend "s3" {
    key = "prod/data-stores/mysql/terraform.tfstate"
  }
}