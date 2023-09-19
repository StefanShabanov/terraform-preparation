#creating a variable for the name of the security group
variable "instance_security_group" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}


#Creating variable for the HTTP port

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  #default= 8080
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "terraform-asg-example"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "terraform-example-alb"
}