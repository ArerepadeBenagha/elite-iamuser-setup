locals {
  max_subnet_length = max(
    length(var.private_subnets),
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc.main.*.id,
      [""],
    ),
    0,
  )

  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "Elite Technology Services"
    Owner       = "EliteInfra"
    Department  = "IT"
    Company     = "EliteSolutions LLC"
    ManagedWith = "Terraform"
    Casecode    = "es20"
  }

  network = {
    Service     = "Elite Technology Services"
    Owner       = "EliteInfra"
    Department  = "IT"
    Company     = "EliteSolutions LLC"
    ManagedWith = "Terraform"
    Casecode    = "es20"
  }

  application = {
    app_name = "publicApp"
    location = "useast2"
    alias    = "Dev"
    ec2      = "public"
  }
}