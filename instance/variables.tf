variable "name" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "resource_group_id" {}
variable "ssh_keys" {}

variable "image_name" {
  default = "ibm-ubuntu-20-04-minimal-amd64-2"
}
variable "profile_name" {
  default = "cx2-2x4"
}
variable "security_groups" {}
variable "tags" {}
variable "zone" {}
variable "user_data" {}
variable "allow_ip_spoofing" {
  type        = bool
  description = "(Optional, bool) Indicates whether IP spoofing is allowed on this interface."
  default     = false
}

variable "force_recovery_time" {
  type        = string
  description = "Timeout (in minutes), to force the is_instance to recover from a perpetual `starting` state."
  default     = "30"
}

variable "security_group_rules" {
  description = "List of security group rules to set on the consul instances"
  default = [
    {
      name      = "consul_tcp_dns_in"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 8600
        port_max = 8600
      }
    },
    {
      name      = "consul_udp_dns_in"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 8600
        port_max = 8600
      }
    },
    {
      name      = "consul_udp_in"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 8301
        port_max = 8302
      }
    },
    {
      name      = "consul_tcp_in"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 8300
        port_max = 8302
      }
    },
    {
      name      = "consul_http"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 8500
        port_max = 8500
      }
    },
    {
      name      = "consul_icmp_in"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      icmp = {
        type = 8
      }
    },
    {
      name      = "allow_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
    }
  ]
}
