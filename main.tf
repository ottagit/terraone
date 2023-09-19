provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world!" > inde.html
              nohup busybox httpd -f -p 8080 &
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = "dev-server"
  }
}

resource "aws_security_group" "instance" {
  name = "dev-server-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}