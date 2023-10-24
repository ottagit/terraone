output "user_arns" {
  value = values(module.users)[*].user_arn
  description = "The ARN of the created IAM users"
}

output "all_iam_users" {
  value = module.users
  description = "All IAM users created"
}