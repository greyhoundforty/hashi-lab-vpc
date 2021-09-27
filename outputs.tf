output "vpc" {
  value = jsonencode(module.vpc.vpc)
}

output "consul_ips" {
  value = module.hashi_cluster[*].primary_ipv4_address
}

output "bastion_ip" {
  value = module.bastion.bastion_public_ip
}

output "vpn_gateway_endpoint" {
  value = module.vpn.vpn_gateway_endpoint
}