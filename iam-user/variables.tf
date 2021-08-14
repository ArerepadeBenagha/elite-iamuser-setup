variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "us-east-2"
}
variable "amis" {
  type = map(any)
  default = {
    us-east-1 = "ami-0bff25b43a4479334" # "ami-048f6ed62451373d9"
    us-west-1 = "ami-0a40aea49c501581d" # "ami-0ff8a91507f77f867"
  }
}
variable "path_to_public_key" {
  description = "public key to be attached to elite virtual machines"
  default     = "mykey.pub"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default     = "cicd_vmkey"
}
variable "instance_type" {
  default = "t2.micro"
}