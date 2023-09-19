#Selecting the provider and that we want to deploy our infrastructure in eu-central-1 region. 
provider "aws" {
  region = "eu-central-1"
}

#Starting an instance (VM)
resource "aws_launch_configuration" "example" {
  image_id        = "ami-04e601abe3e1a910f" # Amazon Machine Image (AMI), in this case it's Ubuntu 20.04
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  #user_data_replace_on_change = true #Terraform will terminate the original instance and launch new one (User Data runs only on first boot). Commented cuz AWS ASG launches new instances by default.

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}



#Output of the public IP of our EC2 instance. 
output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}