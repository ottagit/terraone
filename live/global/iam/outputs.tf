output "user_arns" {
  value = values(module.users)[*].user_arn
  description = "The ARN of the created IAM users"
}

output "all_iam_users" {
  value = module.users
  description = "All IAM users created"
}

# Make all names uppercase
output "upper_usernames" {
  value = [for name in var.user_names : upper(name)]
}

# Make names that meet a given criteria uppercase and return an array
output "upper_usernames_conditional" {
  value = [for name in var.user_names : upper(name) if length(name) > 4]
}

# Return a map of uppercased values
output "upper_names_map" {
  value = {for key, value in var.key_value_map : key => upper(value)}
}

# Loops with the for string directive
# Render the IAM usernames
output "for_string_directive" {
  value = "%{ for name in var.user_names } ${name}, %{ endfor }"
}

# Render the IAM usernames with corresponding indices
output "for_string_directive_index" {
  value = "%{ for index, name in var.user_names } ${name} is at index ${index}, %{endfor}"
}