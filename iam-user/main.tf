module "vpc" {
  source = "./modules/aws-vpc/"

  name = join("-", [local.application.app_name, "elite_vpc"])
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway            = true
  manage_default_security_group = true

  default_security_group_name = join("-", [local.application.app_name, "elite_sg"])
  default_security_group_ingress = [{
    description = "security group that allows ssh and all ingress traffic"
    cidr_blocks = "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    },
    {
      description = "security group that allows ssh and all ingress traffic"
      cidr_blocks = "0.0.0.0/0"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      self        = true
    }
  ]
  default_security_group_egress = [{
    description = "security group that allows ssh and all engress traffic"
    cidr_blocks = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }]

  tags = local.common_tags
}

# Ec2-instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "cicd_vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.mykeypair.key_name
  subnet_id              = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  tags = merge(
    local.application,
    {
      Application = "public-app"
      Name        = format("%s", "cicd_vm")
  })
}
resource "aws_key_pair" "mykeypair" {
  key_name   = var.key_name
  public_key = file(var.path_to_public_key)
}