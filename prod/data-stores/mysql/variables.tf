# Define the username and password for the prod DB

variable "prod_db_username" {
  description = "The username of the prod DB"
  type = string
  sensitive = true
}

variable "prod_db_password" {
  description = "The password of the prod DB"
  type = string
  sensitive = true
}