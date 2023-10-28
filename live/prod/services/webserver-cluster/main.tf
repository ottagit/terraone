module "webserver_cluster" {
  source = "../../../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "batoto-bitange"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size = 3
  max_size = 10
  desired_capacity = 4
  enable_auto_scaling = true
  custom_tags = {
    infra = "Code"
  }
}

# Configure Terraform to store the state in your S3 bucket (with encryption and locking)
terraform {
  backend "s3" {
    key = "prod/services/webserver-cluster/terraform.tfstate"
  }
}