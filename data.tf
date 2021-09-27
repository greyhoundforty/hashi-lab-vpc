
data "ibm_resource_group" "project" {
  name = var.resource_group
}

data "ibm_is_zones" "regional_zones" {
  region = var.region
}

data "ibm_is_ssh_key" "regional_key" {
  name = var.ssh_key
}

data "ibm_resource_instance" "cos_instance" {
  name              = var.cos_instance_name
  resource_group_id = data.ibm_resource_group.project.id
  service           = "cloud-object-storage"
}
