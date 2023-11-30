module "webserver_cluster" {
  source = "github.com/ottagit/modules//services/webserver-cluster?ref=v0.0.1"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "batoto-bitange"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 4
  desired_capacity = 2
}

# Expose an extra port in the staging environment for testing
resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.aws_security_group_id

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

# Configure Terraform to store the state in your S3 bucket (with encryption and locking)
terraform {
  backend "s3" {
    key = "stage/services/webserver-cluster/terraform.tfstate"
  }
}