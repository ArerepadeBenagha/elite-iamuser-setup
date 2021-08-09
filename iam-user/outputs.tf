output "password" {
  value = aws_iam_user_login_profile.eliteuseradmin_login.encrypted_password
}
output "user" {
  value = aws_iam_user.eliteuseradmin.name
}