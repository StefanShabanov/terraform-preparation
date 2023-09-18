#Selecting the provider and that we want to deploy our infrastructure in eu-central-1 region. 
provider "aws" {
  region = "eu-central-1"
}

#Starting an instance (VM)
resource "aws_instance" "exampletf" {
  ami           = "ami-04e601abe3e1a910f" # Amazon Machine Image (AMI), in this case it's Ubuntu 20.04
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example" #naming the instance we just created
  }
}