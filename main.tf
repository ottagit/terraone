provider "aws" {
  region = "us-east-1"
}

variable "server_port" {
  description = "The port the servers will use for HTTP requests"
  type = number
  default = 8080
}

/** create a launch configuration that specifies how to 
configure each EC2 instance in the ASG **/
resource "aws_launch_configuration" "example" {
  image_id = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  // resource attribute reference
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
  EOF

  // Required when using a launch configuration with an ASG
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids

  min_size = 2
  max_size = 10
  
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "dev-server-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}