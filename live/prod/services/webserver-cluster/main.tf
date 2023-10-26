module "webserver_cluster" {
  source = "../../../../../modules/services/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "batoto-bitange"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size = 3
  max_size = 10
  desired_capacity = 4

  custom_tags = {
    Owner = "infra-automation-team"
    # Do not modify this infrastructure manually
    ManagedBy = "terraform"
  }
}

# Define a scheduled action
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 3
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

# Configure Terraform to store the state in your S3 bucket (with encryption and locking)
terraform {
  backend "s3" {
    key = "prod/services/webserver-cluster/terraform.tfstate"
  }
}