provider "aws" {
  region = "us-east-1"
  alias = "region_1"
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
  source = "github.com/ottagit/modules//services/hello-world-app?ref=v0.10.0"

  environment           = "staging"
  db_remote_state_bucket = "batoto-bitange"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  ami                 = data.aws_ami.ubuntu_region1.id
  min_size            = 2
  max_size            = 3
  # desired_capacity    = 2
  enable_auto_scaling = true
}

data "aws_ami" "ubuntu_region1" {
  provider = aws.region_1

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
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


