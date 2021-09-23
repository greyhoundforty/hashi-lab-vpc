module "vpc" {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Module.git"
  name           = "${var.project_name}-vpc"
  resource_group = data.ibm_resource_group.project.id
  tags           = concat(var.tags, ["region:${var.region}", "project:${var.project_name}"])
}

module "public_gateway" {
  count          = length(data.ibm_is_zones.regional_zones.zones)
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Public-Gateway-Module.git"
  name           = "${var.project_name}-${count.index}-gw"
  zone           = data.ibm_is_zones.regional_zones.zones[count.index]
  vpc            = module.vpc.id
  resource_group = data.ibm_resource_group.project.id
  tags           = concat(var.tags, ["zone:${data.ibm_is_zones.regional_zones.zones[count.index]}", "region:${var.region}", "project:${var.project_name}"])
}

module "subnet" {
  count          = length(data.ibm_is_zones.regional_zones.zones)
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.project_name}-${count.index}-subnet"
  resource_group = data.ibm_resource_group.project.id
  network_acl    = module.vpc.default_network_acl
  address_count  = "128"
  vpc            = module.vpc.id
  zone           = data.ibm_is_zones.regional_zones.zones[count.index]
  public_gateway = module.public_gateway[count.index].id
  tags           = concat(var.tags, ["zone:${data.ibm_is_zones.regional_zones.zones[count.index]}", "region:${var.region}", "project:${var.project_name}"])
}

module "bastion" {
  source            = "we-work-in-the-cloud/vpc-bastion/ibm"
  version           = "0.0.7"
  name              = "${var.project_name}-bastion"
  resource_group_id = data.ibm_resource_group.project.id
  vpc_id            = module.vpc.id
  subnet_id         = module.subnet[0].id
  ssh_key_ids       = [data.ibm_is_ssh_key.regional_key.id]
  allow_ssh_from    = var.allow_ssh_from
  create_public_ip  = true
  init_script       = file("install.yml")
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional_zones.zones[0]}", "region:${var.region}", "project:${var.project_name}"])
}

module "hashi_cluster" {
  depends_on        = [module.bastion]
  count             = length(data.ibm_is_zones.regional_zones.zones)
  source            = "./instance"
  vpc_id            = module.vpc.id
  subnet_id         = module.subnet[count.index].id
  ssh_keys          = [data.ibm_is_ssh_key.regional_key.id]
  resource_group_id = data.ibm_resource_group.project.id
  security_groups   = module.bastion.bastion_maintenance_group_id
  name              = "${var.project_name}-consul-${count.index}"
  zone              = data.ibm_is_zones.regional_zones.zones[count.index]
  tags              = concat(var.tags, ["zone:${data.ibm_is_zones.regional_zones.zones[count.index]}", "region:${var.region}", "project:${var.project_name}", "service:consul"])
  user_data         = file("install.yml")
  allow_ip_spoofing = false
}

module "dns" {
  source            = "./dns"
  vpc_id            = module.vpc.id
  resource_group_id = data.ibm_resource_group.project.id
  instance_ips      = module.hashi_cluster[*].primary_ipv4_address
}

module "flowlogs" {
  source = "./flowlogs"
}

