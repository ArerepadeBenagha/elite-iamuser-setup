## Standard Admin User for all Elite Infra Resources
resource "aws_iam_user" "eliteuseradmin" {
  name          = join("-", [local.application.app_name, "eliteuser"])
  path          = "/eliteuseradmin/"
  force_destroy = true
  tags          = local.common_tags
}
resource "aws_iam_access_key" "eliteuseradmin" {
  user = aws_iam_user.eliteuseradmin.name
}
resource "aws_iam_user_policy" "eliteuseradmin" {
  name = join("-", [local.application.app_name, "eliteuseradmin"])
  user = aws_iam_user.eliteuseradmin.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_user_login_profile" "eliteuseradmin_login" {
  user                    = aws_iam_user.eliteuseradmin.name
  pgp_key                 = file("./file.gpg")
  password_length         = 20
  password_reset_required = false
}
resource "aws_iam_user_ssh_key" "eliteuseradmin" {
  username   = aws_iam_user.eliteuseradmin.name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4/+xIM9uAc0Rq5WY2Vpk6vZtyNBO1COE87NCT36Ot0fRpjn1RP+RpRR0NOfTOGdQ19Bp/1rRU7FGcawcPey1a+cBSM98goYk65icwMSUGapD3Y/hRVoswFkAFqe6L0RunO/nlchQI8ABx2qP1egA7JTPpGfN/kkA9/WxObz++WWyCRGd2DxR6FU+hTcH7QLrSz8UzGi0TQSQ0xGTjACnFubkjcEDpkB+P3oUAWGRuagSRmSZ2z1B7bCYV7Q9ur5RHVk5ED6M8xihlTf9ZHXkO97zG5nJMv6IDOV1+dy+PLIP8GgKN/qaQ5H0D2SRjUgCDxmiGwg0mBq1pUF9d2zTgF105Xh+1TqLAjSMBdvzmwEH4u4ymtY578tDTh4X/iCdGSSI7/6HT9YVjH4LPQ/oEVPsPgqi1LHe1CFyebwwVVmADDPFUT2zLj/ne4MMbQaNn6BjmgYC95S4rD++pLdwA0Qq98uGCwFn22/0LvxN1ygMdEB3H5ULKOyeZ9mUZsrk= lbena@LAPTOP-QB0DU4OG"
}
resource "aws_iam_role" "eliteadminrole" {
  name = join("-", [local.application.app_name, "eliteadminrole"])

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_group" "eliteadmingroup" {
  name = join("-", [local.application.app_name, "eliteadmingroup"])
  path = "/eliteadmingroup/"
}
resource "aws_iam_policy" "eliteadmingroup_policy" {
  name        = join("-", [local.application.app_name, "eliteadmingroup_policy"])
  description = "eliteadmingroup policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_policy_attachment" "eliteadminrole_attach" {
  name       = join("-", [local.application.app_name, "eliteadminrole_attach"])
  users      = [aws_iam_user.eliteuseradmin.name]
  roles      = [aws_iam_role.eliteadminrole.name]
  groups     = [aws_iam_group.eliteadmingroup.name]
  policy_arn = aws_iam_policy.eliteadmingroup_policy.arn
}