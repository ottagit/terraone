variable "user_names" {
  description = "Create IAM users with these names"
  type = list(string)
  default = [ "hawi", "otta", "oindoh"]
}

variable "key_value_map" {
  description = "A map of key-value pairs"
  type = map(string)
  default = {
    country = "Kenya"
    city = "Kisumu"
    subcounty = "Kisumu West"
  }
}

variable "give_user_cloudwatch_full_access" {
  description = "If true, user gets full access to CloudWatch"
  type = bool
  default = false
}