variable "user_names" {
  description = "Create IAM users with these names"
  type = list(string)
  default = [ "hawi", "otta", "bitange"]
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