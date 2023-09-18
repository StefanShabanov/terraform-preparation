#Selecting the provider and that we want to deploy our infrastructure in eu-central-1 region. 
provider "aws" {
  region = "eu-central-1"
}

#Starting an instance (VM)
resource "aws_instance" "exampletf" {
  ami           = "ami-0b9094fa2b07038b8" # Amazon Machine Image (AMI), in this case it's Amazon Linux
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }

}