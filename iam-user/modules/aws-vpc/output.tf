output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.main.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.main.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.main.*.cidr_block, [""])[0]
}
output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_vpc.main.*.default_security_group_id, [""])[0]
}
output "subnet_id" {
  description = "The subnet id"
  value       = concat(aws_subnet.main-public.*.id, [""])[0]
}