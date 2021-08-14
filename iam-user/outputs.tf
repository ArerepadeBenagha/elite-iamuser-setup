output "password" {
  description = "Password gpg key output of IAM User"
  value       = aws_iam_user_login_profile.eliteuseradmin_login.encrypted_password
}
output "user" {
  description = "Name of IAM User"
  value       = aws_iam_user.eliteuseradmin.name
}
output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = concat(aws_instance.cicd_vm.*.public_ip, [""])[0]
}
output "id" {
  description = "List of IDs of instances"
  value       = concat(aws_instance.cicd_vm.*.id, [""])[0]
}
output "arn" {
  description = "List of ARNs of instances"
  value       = concat(aws_instance.cicd_vm.*.arn, [""])[0]
}