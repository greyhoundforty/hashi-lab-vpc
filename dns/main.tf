resource "ibm_resource_instance" "project_instance" {
  name              = "${var.project_name}-dns-instance"
  resource_group_id = var.resource_group
  location          = "global"
  service           = "dns-svcs"
  plan              = "standard-dns"
}

resource "ibm_dns_zone" "zone" {
  name        = "gh40.local"
  instance_id = ibm_resource_instance.project_instance.guid
  description = "Private DNS Zone for VPC DNS communication."
  label       = "testlabel"
}

resource "ibm_dns_permitted_network" "permitted_network" {
  instance_id = ibm_resource_instance.project_instance.guid
  zone_id     = ibm_dns_zone.zone.zone_id
  vpc_crn     = var.vpc_id
  type        = "vpc"
}

resource "ibm_dns_resource_record" "hashi" {
  count       = var.instance_count
  instance_id = ibm_resource_instance.project_instance.guid
  zone_id     = ibm_dns_zone.zone.zone_id
  type        = "A"
  name        = "hashi-${count.index + 1}"
  rdata       = element(var.instance_ips, count.index)
  ttl         = 3600
}
