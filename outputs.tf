output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value = module.webserver_cluster.alb_dns_name
}

output "alb_security_group_id" {
  description = "The ID of the Security Group for the load balancer"
  value = module.webserver_cluster.aws_security_group_id
}