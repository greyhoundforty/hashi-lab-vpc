output "vpc" {
  value = jsonencode(module.vpc.vpc)
}

output "consul_ips" {
  value = module.consul_cluster[*].primary_ipv4_address
}

output "bastion_ip" {
  value = module.bastion.bastion_public_ip
}