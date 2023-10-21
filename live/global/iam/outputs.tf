output "user_arns" {
  value = module.users[*].user_arn
  description = "The ARN of the created IAM users"
}