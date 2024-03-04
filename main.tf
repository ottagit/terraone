terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner = "infra-automation-team"
      # Do not modify this infrastructure manually
      ManagedBy = "terraform"
    }
  }
}

module "webserver_cluster" {
  source = "github.com/ottagit/modules//services/webserver-cluster?ref=v0.3.3"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "batoto-bitange"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type       = "t2.micro"
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  enable_auto_scaling = true
}

# Expose an extra port in the staging environment for testing
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.aws_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

terraform {
  backend "s3" {
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    bucket = "batoto-bitange"
    region = "us-east-1"

    dynamodb_table = "terraone-locks"
    encrypt        = true
  }
}


