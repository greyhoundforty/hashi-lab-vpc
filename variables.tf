variable "region" {
  type        = string
  description = "The region where the VPC resources will be deployed."
  default     = "eu-gb"
}

variable "ssh_key" {
  type        = string
  description = "The SSH Key that will be added to the compute instances in the region."
  default     = "hyperion-eu-gb"
}

variable "tags" {
  type        = list(string)
  description = "Default set of tags to add to all resources."
  default     = ["owner:ryantiffany"]
}

variable "resource_group" {
  type        = string
  description = "Resource group where resources will be deployed."
  default     = "CDE"
}

variable "project_name" {
  type        = string
  description = "Name that will be prepended to resources and used as a tag."
  default     = "hashistack"
}

variable "allow_ssh_from" {
  type        = string
  description = "An IP, CIDR, or Security Group that will be allowed SSH access to the bastion host."
  default     = ""
}
