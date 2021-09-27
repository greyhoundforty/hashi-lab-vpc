output "vpn_gateway_endpoint" {
  value = ibm_is_vpn_gateway.lab.public_ip_address
}