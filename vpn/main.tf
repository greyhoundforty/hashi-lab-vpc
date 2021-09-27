resource "ibm_is_vpn_gateway" "lab" {
  name   = "${var.name}-vpn-gw"
  subnet = var.subnet_id
  resource_group = var.resource_group
  mode = "policy"
}

resource "ibm_is_vpn_gateway_connection" "home" {
  name          = "${var.name}-vpn-home-connection"
  vpn_gateway   = ibm_is_vpn_gateway.lab.id
  peer_address  = ibm_is_vpn_gateway.lab.public_ip_address
  preshared_key = var.preshared_key
  local_cidrs = [ibm_is_subnet.testacc_subnet2.ipv4_cidr_block]
  peer_cidrs = [ibm_is_subnet.testacc_subnet1.ipv4_cidr_block]
}