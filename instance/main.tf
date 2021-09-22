locals {
    security_groups = [ibm_is_security_group.consul_security_group.id,var.security_groups]
}

resource "ibm_is_instance" "instance" {
  name           = var.name
  vpc            = var.vpc_id
  zone           = var.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = var.ssh_keys
  resource_group = var.resource_group_id
  

  user_data = var.user_data != "" ? var.user_data : file("${path.module}/init.yml")
  

  primary_network_interface {
    subnet          = var.subnet_id
    security_groups = local.security_groups
    allow_ip_spoofing = var.allow_ip_spoofing != "" ? var.allow_ip_spoofing : false
  }

  boot_volume {
    name = "${var.name}-boot-volume"
  }

  force_recovery_time = var.force_recovery_time
  tags = var.tags
}