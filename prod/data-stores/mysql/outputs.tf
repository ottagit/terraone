output "address" {
  value = aws_db_instance.prod.address
  description = "Connect to the prod DB on this endpoint"
}

output "port" {
  value = aws_db_instance.prod.port
  description = "The port the prod DB is listening on"
}