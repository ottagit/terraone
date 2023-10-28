provider "aws" {
  region = "us-east-1"
}

module "users" {
  source = "../../../../modules/landing-zone/iam-user"

  for_each = toset(var.user_names)
  user_name = each.value
}

# Create an IAM policy allowing read-only access to CloudWatch
resource "aws_iam_policy" "cloudwatch_read_only" {
  name = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [ 
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
     ]
     resources = ["*"]
  }
}

# Create an IAM policy allowing read and write access to CloudWatch
resource "aws_iam_policy" "cloudwatch_full_access" {
  name = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect = "Allow"
    actions = ["cloudwatch:*"]
    resources = ["*"]
  }
}

# Attach CloudWatch full access policy to user
resource "aws_iam_user_policy_attachment" "user_cloudwatch_full_access" {
  count = var.give_user_cloudwatch_full_access ? 1 : 0

  user = var.user_names[2]
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

# Attach CloudWatch read only policy to user
resource "aws_iam_user_policy_attachment" "user_cloudwatch_read_only" {
  count = var.give_user_cloudwatch_full_access ? 0 : 1

  user = var.user_names[2]
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}